module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Encode all possible input combinations
    wire [1:0] inputs = {a, b};

    // Pre-compute all outputs for each input combination
    // Format: {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and}
    reg [6:0] outputs;
    always @(*) begin
        case (inputs)
            2'b00: outputs = 7'b0_1_1_1_0_0_0;  // a=0, b=0
            2'b01: outputs = 7'b0_0_0_1_1_1_0;  // a=0, b=1
            2'b10: outputs = 7'b1_0_0_1_1_1_0;  // a=1, b=0
            2'b11: outputs = 7'b0_1_0_0_0_1_1;  // a=1, b=1
            default: outputs = 7'b0;
        endcase
    end

    // Assign outputs from the pre-computed values
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = outputs;

endmodule