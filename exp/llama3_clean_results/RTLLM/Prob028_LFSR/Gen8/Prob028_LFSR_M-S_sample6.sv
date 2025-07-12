// Simplified LFSR module with integrated feedback calculation
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0;
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

// Minimal testbench to verify the LFSR module
module tb_LFSR;
reg clk, rst;
wire [3:0] out;

LFSR uut (.clk(clk),.rst(rst),.out(out));

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    #100;
    $finish;
end

endmodule