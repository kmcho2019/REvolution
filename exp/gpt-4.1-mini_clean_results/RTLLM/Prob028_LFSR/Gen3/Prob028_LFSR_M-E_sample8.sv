module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    wire feedback;

    // Feedback is inverted XOR of the two LSB bits (out[0] and out[1])
    assign feedback = ~(lfsr_reg[0] ^ lfsr_reg[1]);
    assign out = lfsr_reg;

    always @(posedge clk) begin
        if (rst)
            // Load a non-zero seed on reset to avoid zero lock-up
            lfsr_reg <= 4'b1010;
        else
            // Shift right, insert feedback at MSB
            lfsr_reg <= {feedback, lfsr_reg[3:1]};
    end

endmodule


// Simple testbench to verify LFSR behavior
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Generate clock with 10 time units period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Apply reset
        rst = 1;
        #15;
        rst = 0;

        // Run for several cycles to observe output sequence
        #100;

        // Assert reset again to verify reseeding
        rst = 1;
        #10;
        rst = 0;

        #50;
        $finish;
    end

    // Monitor output values
    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule