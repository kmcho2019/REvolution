// 4-bit LFSR with synchronous reset and separated next-state logic
// Feedback = inverted XOR of bits 3 and 2

module LFSR (
    input  wire       clk,
    input  wire       rst,    // Synchronous active high reset
    output reg [3:0]  out
);

    reg [3:0] state;
    reg [3:0] next_state;
    wire feedback;

    // Compute feedback: inverted XOR of bits 3 and 2 of current state
    assign feedback = ~(state[3] ^ state[2]);

    // Combinational logic to compute next state
    always @(*) begin
        next_state = {state[2:0], feedback};
    end

    // Sequential logic: register update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            state <= 4'b0001;  // Initialize to a non-zero seed to avoid lockup
        else
            state <= next_state;
    end

    // Output is current state
    always @(posedge clk) begin
        out <= state;
    end

endmodule


// Testbench for the restructured LFSR module
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

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;
        #15;        // Assert reset for slightly more than one clock cycle
        rst = 0;

        // Run for multiple cycles to observe full LFSR sequence
        #200;

        $finish;
    end

    // Monitoring
    initial begin
        $display("Time\t rst out");
        $monitor("%4t\t %b   %b", $time, rst, out);
    end

endmodule