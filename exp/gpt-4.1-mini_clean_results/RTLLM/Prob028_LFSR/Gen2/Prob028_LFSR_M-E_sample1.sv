module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    wire feedback;

    // Feedback is XOR of MSB and 2nd MSB, inverted
    assign feedback = ~(lfsr_reg[3] ^ lfsr_reg[2]);
    assign out = lfsr_reg;

    always @(posedge clk) begin
        if (rst)
            // Load a non-zero seed (e.g., 4'b1001) on reset to avoid lockup at zero
            lfsr_reg <= 4'b1001;
        else
            // Shift left, input feedback at LSB
            lfsr_reg <= {lfsr_reg[2:0], feedback};
    end

endmodule


// Simple testbench for verification
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize
        rst = 1;
        #15;
        rst = 0;

        // Run for multiple cycles to observe sequence
        #100;

        // Apply reset again to test reload seed behavior
        rst = 1;
        #10;
        rst = 0;

        #50;
        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule