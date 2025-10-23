module TopModule (
    input  [31:0] in,
    output [31:0] out
);

// Define byte boundaries for clarity and maintainability
localparam BYTE0_L = 7;
localparam BYTE0_H = 0;
localparam BYTE1_L = 15;
localparam BYTE1_H = 8;
localparam BYTE2_L = 23;
localparam BYTE2_H = 16;
localparam BYTE3_L = 31;
localparam BYTE3_H = 24;

// Concatenate bytes in reverse order
assign out = {in[BYTE0_L:BYTE0_H], in[BYTE1_L:BYTE1_H], in[BYTE2_L:BYTE2_H], in[BYTE3_L:BYTE3_H]};

endmodule