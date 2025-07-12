module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    reg [3:0] next_state;
    wire      feedback;

    // Feedback is inverted XOR of bits 3 and 2 of current state
    assign feedback = ~(out[3] ^ out[2]);

    // Combinational logic to determine next state by left shifting and inserting feedback
    always @(*) begin
        next_state = {out[2:0], feedback};
    end

    // Synchronous state update and reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= next_state;
    end

endmodule

// Testbench for LFSR with proper signal declarations
module LFSR_tb;

    reg clk = 0;
    reg rst = 0;
    wire [3:0] out;

    // Instantiate LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        rst = 1;
        #10;
        rst = 0;

        // Let the LFSR run for 50 clock cycles
        repeat (50) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule