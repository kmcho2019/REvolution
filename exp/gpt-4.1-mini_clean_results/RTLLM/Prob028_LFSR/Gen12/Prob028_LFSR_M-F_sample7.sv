module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] state;
    wire feedback;
    wire [3:0] next_state;

    // Calculate feedback as inverted XOR of out[3] and out[2]
    assign feedback = ~(state[3] ^ state[2]);

    // Next state shifts left by one bit and inserts feedback at LSB
    assign next_state = {state[2:0], feedback};

    // State register update on clock edge with synchronous reset to zero
    always @(posedge clk) begin
        if (rst)
            state <= 4'b0000;
        else
            state <= next_state;
    end

    // Output current state
    assign out = state;

endmodule

// Simple testbench for the LFSR module with proper signal declarations and driving
module tb_LFSR;
    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR module
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

    // Stimulus block: reset pulse and run simulation
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t %b  %b", $time, rst, out);

        // Initialize signals
        rst = 1;
        #12;
        rst = 0;

        // Run for some cycles to observe LFSR sequence
        #100;

        $finish;
    end
endmodule