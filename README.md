# JSON Formatter API

Format and validate JSON strings.

## Endpoint

### GET `/format`

**Parameters:**
- `json` (required): JSON string to format

**Example Request:**
```
http://localhost:3026/format?json=%7B%22name%22%3A%22John%22%2C%22age%22%3A30%7D
```

**Example Response:**
```json
{
  "valid": true,
  "formatted": "{\n  \"name\": \"John\",\n  \"age\": 30\n}"
}
```
