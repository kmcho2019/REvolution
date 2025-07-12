module LFSR #(
    parameter WIDTH = 4,
    // TAPS defines which bits are XORed for feedback: bits indexed 0..WIDTH-1
    // For a maximal 4-bit LFSR with polynomial x^4 + x^3 + 1, taps are bit 3 and 2
    parameter [WIDTH-1:0] TAPS = 4'b1100
)(
    input  wire               clk,
    input  wire               rst,    // synchronous active-high reset
    output reg  [WIDTH-1:0]  out
);

    // Function to compute XOR of tapped bits
    function automatic bit feedback_fn(input [WIDTH-1:0] state);
        integer i;
        bit fb;
        begin
            fb = 0;
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (TAPS[i])
                    fb = fb ^ state[i];
            end
            feedback_fn = fb;
        end
    endfunction

    always @(posedge clk) begin
        if (rst)
            out <= { {(WIDTH-1){1'b0}}, 1'b1 }; // seed with LSB=1, others zero
        else begin
            // Shift left and insert feedback at LSB
            out <= {out[WIDTH-2:0], feedback_fn(out)};
        end
    end

endmodule


// Testbench for the parameterized LFSR
`timescale 1ns / 1ps
module tb_LFSR;

    localparam WIDTH = 4;

    reg                 clk;
    reg                 rst;
    wire [WIDTH-1:0]    out;

    // Instantiate LFSR with default taps for maximal 4-bit LFSR
    LFSR #(
        .WIDTH(WIDTH),
        .TAPS(4'b1100)
    ) uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Apply synchronous reset for one clock cycle
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run for 20 clock cycles
        repeat (20) @(posedge clk);

        $finish;
    end

    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t %b %b", $time, rst, out);
    end

endmodule