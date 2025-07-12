module TopModule (
    input  wire a,
    input  wire b,
    output reg  out_and,
    output reg  out_or,
    output reg  out_xor,
    output reg  out_nand,
    output reg  out_nor,
    output reg  out_xnor,
    output reg  out_anotb
);

always @(*) begin
    // Pack all outputs into a local vector for clarity
    // bit [6] = out_anotb
    // bit [5] = out_xnor
    // bit [4] = out_nor
    // bit [3] = out_nand
    // bit [2] = out_xor
    // bit [1] = out_or
    // bit [0] = out_and
    reg [6:0] results;

    results[0] = a & b;
    results[1] = a | b;
    results[2] = a ^ b;
    results[3] = ~(a & b);
    results[4] = ~(a | b);
    results[5] = ~(a ^ b);
    results[6] = a & (~b);

    out_and   = results[0];
    out_or    = results[1];
    out_xor   = results[2];
    out_nand  = results[3];
    out_nor   = results[4];
    out_xnor  = results[5];
    out_anotb = results[6];
end

endmodule