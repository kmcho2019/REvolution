module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0;
    end else begin
        // Corrected feedback calculation and shift operation
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule

// Example Testbench
module LFSR_test;
reg clk;
reg rst;
wire [3:0] out;

LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever begin
        #5;
        clk = ~clk;
    end
end

initial begin
    $dumpfile("LFSR.vcd");
    $dumpvars(0, LFSR_test);
    #100;
    $finish;
end

endmodule