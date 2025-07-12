module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

reg [7:0] lut[8]; // 2^3 = 8 possible combinations for 3 inputs
integer i;

initial begin
    // Initialize the LUT based on the Karnaugh map
    lut[0] = 1'b0; // a=0, b=0, c=0
    lut[1] = 1'b0; // a=0, b=0, c=1
    lut[2] = 1'b1; // a=0, b=1, c=0
    lut[3] = 1'b1; // a=0, b=1, c=1
    lut[4] = 1'b0; // a=1, b=0, c=0
    lut[5] = 1'b1; // a=1, b=0, c=1
    lut[6] = 1'b1; // a=1, b=1, c=0
    lut[7] = 1'b1; // a=1, b=1, c=1
end

always @(*) begin
    case ({a, b, c})
        3'b000: out = lut[0];
        3'b001: out = lut[1];
        3'b010: out = lut[2];
        3'b011: out = lut[3];
        3'b100: out = lut[4];
        3'b101: out = lut[5];
        3'b110: out = lut[6];
        3'b111: out = lut[7];
    endcase
end

endmodule