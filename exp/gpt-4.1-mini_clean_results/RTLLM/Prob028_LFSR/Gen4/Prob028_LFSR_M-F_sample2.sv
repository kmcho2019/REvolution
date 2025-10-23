// 4-bit LFSR with feedback inversion of XOR(out[3], out[2])
module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    // Feedback is inversion of XOR of bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // Initialize to zero on reset
        end else begin
            out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
        end
    end

endmodule


// Testbench for the LFSR module
module tb_LFSR();

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate LFSR module with matching port widths
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time unit period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize reset
        rst = 1;
        #15;      // Hold reset high for 15 time units (1.5 clock cycles)
        rst = 0;

        // Run for some cycles
        #100;

        // Optionally re-assert reset to check initialization
        rst = 1;
        #10;
        rst = 0;

        #30;

        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst, out);
    end

endmodule