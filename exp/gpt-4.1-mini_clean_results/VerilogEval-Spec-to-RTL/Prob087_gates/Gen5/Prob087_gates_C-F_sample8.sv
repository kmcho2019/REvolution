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

    // Bit mapping in outputs_comb:
    // [6] - out_and
    // [5] - out_or
    // [4] - out_xor
    // [3] - out_nand
    // [2] - out_nor
    // [1] - out_xnor
    // [0] - out_anotb

    always @(*) begin
        // Shared intermediate signals inside the always block
        wire and_ab = a & b;
        wire or_ab  = a | b;
        wire xor_ab = a ^ b;

        outputs_comb[6] = and_ab;          // out_and
        outputs_comb[5] = or_ab;           // out_or
        outputs_comb[4] = xor_ab;          // out_xor
        outputs_comb[3] = ~and_ab;         // out_nand
        outputs_comb[2] = ~or_ab;          // out_nor
        outputs_comb[1] = ~xor_ab;         // out_xnor
        outputs_comb[0] = a & (~b);        // out_anotb
    end

    assign out_and   = outputs_comb[6];
    assign out_or    = outputs_comb[5];
    assign out_xor   = outputs_comb[4];
    assign out_nand  = outputs_comb[3];
    assign out_nor   = outputs_comb[2];
    assign out_xnor  = outputs_comb[1];
    assign out_anotb = outputs_comb[0];

endmodule