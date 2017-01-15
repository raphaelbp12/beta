# visit-rio-api
API with all available core resources

NOTE: This document is a **work in progress**.


# Group Posts
This section groups visit.rio WP Posts.


## Posts Collection [api/v1/posts]
A Collection of posts.


### List All Restaurants [GET]

+ Request
  ```js
  Params:
    taxonomy: <<string>>
    term: <<string>>
  ```

+ Response 200 (application/json)

    ```js
  {
  "meta": {
    "success": true,
    "locale": "en"
  },
  "total": 88,
  "posts": [
    {
      "id": 874,
      "title": "Arpoador",
      "images": [
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/3756934228_e74b0275bb_b.jpg",
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/3877685881_f83de949a7_b.jpg",
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/8447961920_0be1727b85_k.jpg",
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/8497934703_c52e39690d_k.jpg",
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/8499036920_e0d626a650_k.jpg",
        "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/08/4082365541_f11549b022_o.jpg"
      ],
      "content": "Uma das praias preferidas de cariocas e turistas pela beleza de sua paisagem e pela prática do surfe, tanto no verão quanto no inverno. Possui 800m de extensão entre o Forte de Copacabana e a Rua Francisco Otaviano com Av. Vieira Souto. O nome do local provém do fato de ser possível, no passado, arpoarem-se baleias nas proximidades da costa. Não se esqueça de visitar as pedras do Arpoador, o local mais lindo para se apreciar o mar e o pôr do sol!",
      "description": "Entre o Forte de Copacabana e a Praia de Ipanema, o Arpoador é um dos pontos mais famosos da orla da cidade.",
      "taxonomys": {
        "precos": [
          {
            "term_id": 41,
            "name": "Grátis",
            "slug": "gratuito"
          }
        ],
        "cat_que_fazer": [
          {
            "term_id": 46,
            "name": "Ao ar livre",
            "slug": "ao-ar-livre"
          },
          {
            "term_id": 56,
            "name": "Praias",
            "slug": "praias"
          }
        ],
        "post_tag": [
          {
            "term_id": 57,
            "name": "Praias",
            "slug": "praias"
          },
          {
            "term_id": 58,
            "name": "Arpoador",
            "slug": "arpoador"
          },
          {
            "term_id": 59,
            "name": "Ipanema",
            "slug": "ipanema"
          },
          {
            "term_id": 60,
            "name": "Zona Sul",
            "slug": "zona-sul"
          }
        ],
        "language": [
          {
            "term_id": 492,
            "name": "Português",
            "slug": "pt"
          }
        ],
        "post_translations": [
          {
            "term_id": 2591,
            "name": "pll_5677013256a33",
            "slug": "pll_5677013256a33"
          }
        ]
      },
      "postmetas": {
        "imagem_banner": {
          "original_image": "1742",
          "cropped_image": {
            "image": "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/10/4082365541_f11549b022_o_1920x500_acf_cropped.jpg",
            "preview": "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/2015/10/preview_4082365541_f11549b022_o_1920x500_acf_cropped.jpg"
          }
        },
        "galeria": [
          "948",
          "949",
          "951",
          "952",
          "953",
          "1742"
        ],
        "infos_0_cep": "22080-040",
        "infos_0_endereco": "Rua Francisco Otaviano com a Avenida Vieira Souto",
        "infos_0_bairro": "Ipanema",
        "infos_0_telefones": "1",
        "infos": "1",
        "infos_0_logradouro": "Rua Francisco Otaviano",
        "negocios": "0"
      }
    }
  ]
    ```
