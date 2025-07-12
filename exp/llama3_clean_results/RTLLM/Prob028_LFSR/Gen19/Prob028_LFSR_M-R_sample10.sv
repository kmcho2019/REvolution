// Linear Feedback Shift Register (LFSR) module
module LFSR (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // Calculate feedback by XORing the most significant and second most significant bits and inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

// Example testbench for verification
module LFSR_testbench;
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
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end

    initial begin
        $dumpvars();
        $dumpfile("LFSR.vcd");
    end

endmodule