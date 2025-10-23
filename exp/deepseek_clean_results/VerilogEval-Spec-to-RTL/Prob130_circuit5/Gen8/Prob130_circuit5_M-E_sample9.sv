module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Create a 4-entry memory (each entry is 4 bits)
reg [3:0] lut [0:3];

// Initialize the LUT
always @(*) begin
    lut[0] = b;
    lut[1] = e;
    lut[2] = a;
    lut[3] = d;
end

// Select output based on lower 2 bits of c, or default case
assign q = (c < 4) ? lut[c[1:0]] : 4'b1111;

endmodule