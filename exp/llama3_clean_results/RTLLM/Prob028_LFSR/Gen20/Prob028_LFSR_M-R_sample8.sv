module LFSR (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

    // Combinational logic for feedback calculation
    wire fb;
    assign fb = ~(out[3] ^ out[2]);

    // Sequential logic for updating the LFSR state
    always @(posedge clk) begin
        if (rst) begin
            // Initialize state to zero on reset
            out <= 4'b0000;
        end else begin
            // Shift bits and insert feedback at LSB
            out <= {out[2:0], fb};
        end
    end

endmodule

// Testbench for verification
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
        $monitor("out = %b", out);
    end

endmodule