module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg [3:0] next_state;
    wire feedback;

    // Calculate feedback as inversion of XOR between out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    // Combinational logic for next state
    always @(*) begin
        // Shift left by 1 bit, insert feedback at LSB
        next_state = {out[2:0], feedback};
    end

    // Sequential logic: update state on clock edge or reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000; // Initialize to zero on reset
        else
            out <= next_state;
    end

endmodule


// Testbench for the refactored LFSR module
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

    // Test stimulus
    initial begin
        rst = 1;       // Assert reset
        #15;
        rst = 0;       // Deassert reset

        // Run for some cycles to observe output sequence
        #100;

        rst = 1;       // Assert reset again
        #10;
        rst = 0;       // Deassert reset

        #50;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule