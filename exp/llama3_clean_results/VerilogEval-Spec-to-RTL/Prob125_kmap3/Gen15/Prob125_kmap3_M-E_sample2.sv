module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Ignored due to don't-care condition
    output out
);

// Define the lookup table based on the Karnaugh map
// Each entry corresponds to a combination of 'a', 'b', and 'c'
// 'd' is ignored as it's a don't-care condition
reg [1:0] lut_out;

always @(*) begin
    case ({a, b, c})
        3'b000: lut_out = 1'b0; // a=0, b=0, c=0
        3'b001: lut_out = 1'b1; // a=0, b=0, c=1
        3'b010: lut_out = 1'b1; // a=0, b=1, c=0
        3'b011: lut_out = 1'b1; // a=0, b=1, c=1
        3'b100: lut_out = 1'b1; // a=1, b=0, c=0
        3'b101: lut_out = 1'b1; // a=1, b=0, c=1
        3'b110: lut_out = 1'b1; // a=1, b=1, c=0
        3'b111: lut_out = 1'b1; // a=1, b=1, c=1
        default: lut_out = 1'b0; // Should not occur
    endcase
end

assign out = lut_out;

endmodule