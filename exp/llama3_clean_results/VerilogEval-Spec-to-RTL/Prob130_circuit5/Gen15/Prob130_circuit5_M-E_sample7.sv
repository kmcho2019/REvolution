module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Define the lookup table
wire [3:0] lut_out;
always @(*)
begin
    case (c[1:0])
        2'b00: lut_out = b;
        2'b01: lut_out = e;
        2'b10: lut_out = a;
        2'b11: lut_out = d;
        default: lut_out = 4'b0000;
    endcase
end

// Override output if c[3:2] != 2'b00
assign q = (c[3:2] != 2'b00) ? 4'b1111 : lut_out;

endmodule