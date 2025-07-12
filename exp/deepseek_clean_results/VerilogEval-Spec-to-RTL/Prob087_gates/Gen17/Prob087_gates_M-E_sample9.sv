module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Concatenate inputs to form 2-bit address
    wire [1:0] sel = {a, b};

    // LUT implementation for all outputs
    reg [6:0] lut_out;
    always @(*) begin
        case (sel)
            2'b00: lut_out = 7'b0001110;
            2'b01: lut_out = 7'b0110010;
            2'b10: lut_out = 7'b0110001;
            2'b11: lut_out = 7'b1100100;
        endcase
    end

    // Assign outputs from LUT
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut_out;

endmodule