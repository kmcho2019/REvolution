module TopModule(
    input [254:0] in,
    output [7:0] out
);

reg [254:0] lfsr;
reg [7:0] count;
reg clk;

initial begin
    lfsr = in;
    count = 0;
    clk = 0;
end

always @(posedge clk) begin
    lfsr = {lfsr[253:0], lfsr[254] ^ lfsr[0] ^ lfsr[2] ^ lfsr[3] ^ lfsr[5]};
    count = count + lfsr[254];
end

always #10 clk = ~clk;

assign out = count;

endmodule