module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [2:0] pos;  // current bit position (0 to 7)

    // Sequential logic: update position on rising edge of clock or reset
    always @(posedge clk) begin
        if (reset)
            pos <= 3'd0;
        else
            pos <= pos + 3'd1; // wraps around naturally due to 3-bit width
    end

    // Combinational output: one-hot encoding via left shift
    assign out = 8'b1 << pos;

endmodule