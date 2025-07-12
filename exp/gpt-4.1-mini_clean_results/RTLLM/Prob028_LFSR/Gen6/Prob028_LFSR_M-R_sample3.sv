// 4-bit LFSR with asynchronous reset and separated feedback calculation
// Feedback = inverted XOR of bits 3 and 2
// Output continuously assigned from internal register

module LFSR (
    input  wire       clk,
    input  wire       rst,   // Asynchronous active high reset
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;

    // Feedback bit is the inverted XOR of bits 3 and 2
    wire feedback = ~(lfsr_reg[3] ^ lfsr_reg[2]);

    // Asynchronous reset, synchronous update of LFSR register
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr_reg <= 4'b0001;  // Non-zero seed to avoid lockup
        else
            lfsr_reg <= {lfsr_reg[2:0], feedback};
    end

    // Continuous assignment of output to internal register
    assign out = lfsr_reg;

endmodule


// Testbench for the refactored LFSR module
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;
        #12;        // Hold reset for a bit more than one clock cycle
        rst = 0;

        // Run for multiple cycles to observe full LFSR sequence
        #1000;

        $finish;
    end

    // Monitor changes with timestamp
    initial begin
        $display("Time   rst out");
        $monitor("%4t   %b   %b", $time, rst, out);
    end

endmodule