class TermTaxonomy < ActiveRecord::Base
  self.table_name = 'vr_term_taxonomy'

  has_many :term_relationships, foreign_key: 'term_taxonomy_id'
  has_many :posts, through: :term_relationships

  has_one :term, foreign_key: 'term_id'

  # Funcao padrao para selecionar a categoria
  def self.taxonomy(part)
    where(taxonomy: part)
  end

  def self.term(part)
    joins(:term).where('vr_terms.slug = ?',part).take
  end

  def self.taxonomy(part)
    joins(:term).where('vr_term_taxonomy.taxonomy = ?',part)
  end

  def self.get_terms_slugs_by_taxonomy(part)
    termtaxonomys = TermTaxonomy.taxonomy(part)

    terms_slugs = []

    termtaxonomys.each do |termtaxonomy|
      terms_slugs.push(termtaxonomy.term.slug)
    end

    terms_slugs.each do |slug|
      p slug
    end
  end

  def self.get_info()
    info = [["aeroportos", "airports", "aeropuertos"],
            ["agencia-de-viagens", "travel-agencies", "agencia-de-viajes"],
            ["aluguel-de-bicicleta", "bike-rental", "alquiler-de-bicicleta"],
            ["aluguel-de-carros", "car-rental", "alquiler-de-coche"],
            ["cambio", "currency-exchange", "casa-de-cambio"],
            ["companhias-aereas", "airlines", "companias-aereas"],
            ["companhias-maritimas", "ship-companies", "companias-maritimas"],
            ["consulados", "consulates", "consulados-es"],
            ["correios", "post-offices", "correos"],
            ["informacoes-turisticas", "tourist-information", "informaciones-turisticas"],
            ["porto", "port", "puerto"],
            ["translado-aeroportohoteis", "transfer-airporthotels", "translados-aeropuertohoteles"],
            ["telefones-uteis-atendimentos-especiais", "useful-numbers-special-services", "telefonos-utiles-atendimientos-especiales"],
            ["taxi-aereo", "air-taxi", "taxi-aereo-es"],
            ["terminais-rodoviarios", "bus-terminals", "terminal-de-omnibus"],
            ["trens-urbanos", "city-trains", "trenes-urbanos"]]
  end

  def self.get_terms_info()
    infos = TermTaxonomy.get_info()
    terms = []

    Rails.cache.fetch("terms_info") do
      infos.each do |info|
        terms_pre = []
        info.each do |slug|
          terms_pre.push(TermTaxonomy.term(slug).term)
        end
        terms.push(terms_pre)
      end

      terms
    end
  end
end
