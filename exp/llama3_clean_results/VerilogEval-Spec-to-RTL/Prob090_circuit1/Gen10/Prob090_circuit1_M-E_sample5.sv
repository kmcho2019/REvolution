// Novel implementation of the TopModule using a lookup table (LUT)
module TopModule(
    input  a,
    input  b,
    output q
);

// Define the LUT
reg [1:0] lut_input;
reg q;

always @(*) begin
    lut_input = {a, b};
    case (lut_input)
        2'b00: q = 1'b0;
        2'b01: q = 1'b0;
        2'b10: q = 1'b0;
        2'b11: q = 1'b1;
    endcase
end

endmodule