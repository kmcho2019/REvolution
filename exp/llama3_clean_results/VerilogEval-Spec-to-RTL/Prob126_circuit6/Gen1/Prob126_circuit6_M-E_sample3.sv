module TopModule(
    input  [2:0] a,
    output reg [15:0] q
);

reg [15:0] lut [7:0];

initial begin
    lut[0] = 16'h1232; // a = 0, q = 1232
    lut[1] = 16'haee0; // a = 1, q = aee0
    lut[2] = 16'h27d4; // a = 2, q = 27d4
    lut[3] = 16'h5a0e; // a = 3, q = 5a0e
    lut[4] = 16'h2066; // a = 4, q = 2066
    lut[5] = 16'h64ce; // a = 5, q = 64ce
    lut[6] = 16'hc526; // a = 6, q = c526
    lut[7] = 16'h2f19; // a = 7, q = 2f19
end

always @(*) begin
    q = lut[a];
end

endmodule