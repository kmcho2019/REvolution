// LFSR module unchanged
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    // Compute feedback combinationally
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule

// Testbench to properly drive LFSR inputs and observe outputs
module LFSR_tb;

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
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize reset
        rst = 1;
        #15;      // Hold reset for at least one clock cycle
        rst = 0;

        // Run for a number of clock cycles to observe output
        #100;

        $finish;
    end

    // Optional: Display outputs for debugging
    initial begin
        $monitor("Time=%0t rst=%b out=%b", $time, rst, out);
    end

endmodule