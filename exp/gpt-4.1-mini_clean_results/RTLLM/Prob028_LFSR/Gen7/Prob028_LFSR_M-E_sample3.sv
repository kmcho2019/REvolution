// 4-bit LFSR with explicit combinational next-state logic
// Feedback = inverted XOR of bits 3 and 2 of the current state
// Asynchronous active-high reset to non-zero seed (4'b1001)

module LFSR (
    input  wire       clk,
    input  wire       rst,  // Asynchronous active-high reset
    output reg [3:0]  out
);

    // Compute feedback bit (inverted XOR of bits 3 and 2)
    wire feedback = ~(out[3] ^ out[2]);

    // Combinational next state logic
    wire [3:0] next_state;
    assign next_state[3] = out[2];      // bit3 gets previous bit2
    assign next_state[2] = out[1];      // bit2 gets previous bit1
    assign next_state[1] = out[0];      // bit1 gets previous bit0
    assign next_state[0] = feedback;    // bit0 gets feedback

    // Sequential update with asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b1001;  // Non-zero seed to avoid lock-up
        end else begin
            out <= next_state;
        end
    end

endmodule

// Testbench for the LFSR module
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%4t\t%b\t%b\t%04b", $time, clk, rst, out);

        rst = 1;
        #12;          // Hold reset for >1 clock cycle
        rst = 0;
        #200;         // Run for 20 clock cycles (20*10 time units)

        $finish;
    end

endmodule