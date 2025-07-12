module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    // feedback is inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            // Initialize to non-zero seed to avoid zero-lock
            out <= 4'b0001;
        end else begin
            // Shift left each bit, insert feedback at LSB
            // out[3] <= out[2]
            // out[2] <= out[1]
            // out[1] <= out[0]
            // out[0] <= feedback
            out[3] <= out[2];
            out[2] <= out[1];
            out[1] <= out[0];
            out[0] <= feedback;
        end
    end

endmodule

// Self-contained testbench
module tb_LFSR;

    reg        clk_tb;
    reg        rst_tb;
    wire [3:0] out_tb;

    // Instantiate LFSR
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10-time unit period
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Test sequence: reset, then run 20 cycles
    initial begin
        rst_tb = 1;
        #15;
        rst_tb = 0;
        repeat (20) @(posedge clk_tb);
        $finish;
    end

    // Display outputs on every posedge clock
    initial begin
        $display("Time  Reset  LFSR_out");
        $monitor("%4t   %b      %b", $time, rst_tb, out_tb);
    end

endmodule