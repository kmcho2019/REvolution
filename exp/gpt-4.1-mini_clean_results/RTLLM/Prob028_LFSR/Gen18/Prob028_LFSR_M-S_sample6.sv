module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst)
        out <= 4'b0001;       // non-zero seed
    else
        out <= {out[2:0], feedback};
end

endmodule

module tb_LFSR;

reg clk = 0;
reg rst = 1;
wire [3:0] out;

LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

always #5 clk = ~clk;

initial begin
    #10 rst = 0;     // release reset
    #100 $finish;    // end simulation
end

endmodule