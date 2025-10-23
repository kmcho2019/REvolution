module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR dut (clk, rst, out);

    always #5 clk = ~clk;

    initial begin
        #15 rst = 0;
        #80 $finish;
    end
endmodule