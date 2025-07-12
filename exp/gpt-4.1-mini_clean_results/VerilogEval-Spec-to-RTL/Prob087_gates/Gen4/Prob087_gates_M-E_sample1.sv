module TopModule (
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    reg [6:0] outputs_comb;

    // Bit assignments in outputs_comb:
    // [6] - out_and
    // [5] - out_or
    // [4] - out_xor
    // [3] - out_nand
    // [2] - out_nor
    // [1] - out_xnor
    // [0] - out_anotb

    always @(*) begin
        outputs_comb[6] = a & b;        // out_and
        outputs_comb[5] = a | b;        // out_or
        outputs_comb[4] = a ^ b;        // out_xor
        outputs_comb[3] = ~(a & b);     // out_nand
        outputs_comb[2] = ~(a | b);     // out_nor
        outputs_comb[1] = ~(a ^ b);     // out_xnor
        outputs_comb[0] = a & ~b;       // out_anotb
    end

    assign out_and   = outputs_comb[6];
    assign out_or    = outputs_comb[5];
    assign out_xor   = outputs_comb[4];
    assign out_nand  = outputs_comb[3];
    assign out_nor   = outputs_comb[2];
    assign out_xnor  = outputs_comb[1];
    assign out_anotb = outputs_comb[0];

endmodule