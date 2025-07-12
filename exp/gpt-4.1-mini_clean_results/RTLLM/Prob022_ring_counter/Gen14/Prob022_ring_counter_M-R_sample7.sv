module ring_counter (
    input  clk,
    input  reset,
    output [7:0] out
);

    reg [2:0] pos; // Position index: 0 to 7

    // Sequential logic: increment pos on clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            pos <= 3'b000; // start at position 0 -> LSB high
        else
            pos <= pos + 3'b001; // increment modulo 8 (3-bit wraparound)
    end

    // Combinational logic: one-hot decode pos to out
    assign out = 8'b1 << pos;

endmodule