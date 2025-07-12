// 4-bit LFSR with asynchronous reset and continuous feedback calculation
// Feedback = inverted XOR of bits 3 and 2

module LFSR (
    input  wire       clk,
    input  wire       rst,    // Asynchronous active high reset
    output wire [3:0] out
);

    reg [3:0] state;
    wire feedback;

    // Compute feedback: inverted XOR of MSB and second MSB of current state
    assign feedback = ~(state[3] ^ state[2]);

    // Assign output to current state
    assign out = state;

    // State update on clock or async reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= 4'b0001;  // Non-zero seed to avoid lockup
        else
            state <= {state[2:0], feedback};
    end

endmodule


// Clean testbench for the LFSR module
module LFSR_tb;

    reg        clk;
    reg        rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
        // Initialize reset
        rst = 1;        // Assert reset
        #15;
        rst = 0;        // Deassert reset

        // Let the LFSR run for 200 time units
        #200;

        $finish;
    end

    // Monitor output signals
    initial begin
        $display("Time\t rst out");
        $monitor("%4t\t %b   %b", $time, rst, out);
    end

endmodule