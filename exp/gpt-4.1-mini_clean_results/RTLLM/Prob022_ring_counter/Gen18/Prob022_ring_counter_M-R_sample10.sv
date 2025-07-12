module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] state;

    // State counter: increments on each clock, resets to 0 on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000; // Initialize position to 0
        end else begin
            state <= state + 3'd1; // Increment with wrap-around (3-bit)
        end
    end

    // Combinational output: one-hot encoding of current state position
    assign out = 8'b00000001 << state;

endmodule