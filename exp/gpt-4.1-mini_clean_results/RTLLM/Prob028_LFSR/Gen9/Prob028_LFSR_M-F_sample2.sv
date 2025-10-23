// 4-bit LFSR with synchronous reset and separated next-state logic
// Feedback = inverted XOR of bits 3 and 2

module LFSR (
    input  wire       clk,
    input  wire       rst,    // Synchronous active high reset
    output reg [3:0]  out
);

    reg [3:0] state;
    wire feedback;

    // Compute feedback: inverted XOR of bits 3 and 2 of current state
    assign feedback = ~(state[3] ^ state[2]);

    // Sequential logic: register update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            state <= 4'b0001;  // Initialize to a non-zero seed to avoid lockup
        else
            state <= {state[2:0], feedback};
    end

    // Output current state
    always @(posedge clk) begin
        out <= state;
    end

endmodule


// Testbench for the LFSR module with proper signal declarations and stimulus
module LFSR_tb;

    reg clk;             // Clock must be reg to drive procedural assignment
    reg rst;             // Reset must be reg for procedural assignment
    wire [3:0] out;      // Output is wire with matching width

    // Instantiate LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus block
    initial begin
        rst = 1;           // Assert reset
        #15;               // Hold reset > 1 clock cycle (clk period = 10)
        rst = 0;           // Deassert reset

        #200;              // Run for some time to observe sequence

        $finish;
    end

    // Monitor signals
    initial begin
        $display("Time\t rst out");
        $monitor("%4t\t  %b   %b", $time, rst, out);
    end

endmodule