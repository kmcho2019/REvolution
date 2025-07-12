module LFSR (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            // Calculate feedback by XORing MSB and second MSB, then inverting
            reg fb = ~(out[3] ^ out[2]);
            // Shift bits left and insert feedback at LSB
            out <= {out[2:0], fb};
        end
    end

endmodule

// Simplified testbench for verification
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
        $dumpfile("LFSR_testbench.vcd");
        $dumpvars(0, LFSR_testbench);
        #10;
        rst = 1;
        #10;
        rst = 0;
        clk = 0;
        #5;
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end

    initial begin
        $monitor("out = %b", out);
    end

endmodule