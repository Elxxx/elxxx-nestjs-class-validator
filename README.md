# @elxxx/nestjs-class-validator

**@elxxx/nestjs-class-validator** @elxxx/nestjs-class-validator es una extensión ligera para NestJS que provee mensajes de error localizados para class-validator sin necesidad de personalizar cada decorador.
Permite manejar errores de validación en múltiples idiomas mediante archivos JSON estándar e integra directamente con ValidationPipe y ExceptionFilter.

## ✨ Características principales

- 🌍 Soporta múltiples idiomas (en, vi, es)
- 📥 Lee la cabecera Accept-Language para determinar el idioma dinámicamente
- 📦 Integración lista para usar con el ValidationPipe de NestJS
- 🧩 Archivos de mensajes personalizables para cada locale
- ⚡ Cero configuración necesaria en cada decorador

## 📦 Instalación

**npm:**

```bash
npm @elxxx/nestjs-class-validator
```

**yarn:**

```bash
yarn add @elxxx/nestjs-class-validator
```

**pnpm:**

```bash
pnpm add @elxxx/nestjs-class-validator
```

## 🚀 Uso

### 1. Registrar Pipes y Filtros globales

Utiliza las clases de excepción y filtro provistas para aplicar validación localizada en toda la aplicación.

```ts
// main.ts
import {
  I18nValidationException,
  I18nValidationFilter,
} from '@elxxx/nestjs-class-validator';
import { ValidationPipe } from '@nestjs/common';
import { HttpAdapterHost, NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      exceptionFactory: (errors) => new I18nValidationException(errors),
    }),
  );

  const adapterHost = app.get(HttpAdapterHost);
  app.useGlobalFilters(
    new I18nValidationFilter(adapterHost, { fallbackLanguage: 'es' }),
  );

  await app.listen(3000);
}

bootstrap();
```

### 2. Crear DTO con class-validator

```ts
import { IsEmail, IsNotEmpty } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsNotEmpty()
  name: string;
}
```

### 3. Enviar una petición con cabecera `Accept-Language`

```http
POST /users
Accept-Language: vi
Content-Type: application/json

{
  "email": "not-an-email"
}
```

Respuesta:

```json
{
  "statusCode": 400,
  "message": "email phải là email hợp lệ",
  "error": "Bad Request"
}
```

## 🛠️ Issues y Contribuciones

Siéntete libre de abrir [issues](https://github.com/Elxxx/elxxx-nestjs-class-validator-i18n-1.0.0/issues) o enviar pull requests para mejoras, correcciones de errores o soporte de nuevos idiomas.

## 📄 License

Licencia MIT © [elxxx](https://github.com/Elxxx)
