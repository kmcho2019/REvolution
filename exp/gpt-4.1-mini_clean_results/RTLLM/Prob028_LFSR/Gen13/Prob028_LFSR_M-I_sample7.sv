module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Feedback is XOR of bit 3 and bit 2, inverted as specified
    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;  // Non-zero seed to ensure maximal-length pseudo-random sequence
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for the LFSR module
module tb_LFSR;

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

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        #15;          // Hold reset for some time
        
        rst = 0;      // Release reset

        // Run for 200 time units to observe LFSR sequence
        #200;

        $finish;      // End simulation
    end

    // Monitor outputs and detect zero locking state
    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst, out);
    end

    // Check for lock-up at zero state (which should never happen with non-zero seed)
    always @(posedge clk) begin
        if (!rst && out == 4'b0000) begin
            $display("Warning: LFSR locked at zero state at time %0t!", $time);
        end
    end

endmodule