module TopModule(
    input  [2:0] a,
    output reg [15:0] q
);

reg [15:0] values [7:0];

always @(*) begin
    values[0] = 16'h1232;
    values[1] = 16'haee0;
    values[2] = 16'h27d4;
    values[3] = 16'h5a0e;
    values[4] = 16'h2066;
    values[5] = 16'h64ce;
    values[6] = 16'hc526;
    values[7] = 16'h2f19;
    
    q = values[a];
end

endmodule