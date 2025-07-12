module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] shift_reg; // 8-bit shift register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Calculate next state by shifting right and handling wrap-around
        shift_reg <= {shift_reg[6:0], shift_reg[7]}; 
        // alternative implementation to avoid concatenation issue
        // reg [7:0] next_state;
        // next_state = shift_reg >> 1;
        // if (shift_reg[7]) begin
        //     next_state[0] = 1'b1;
        // end
        // shift_reg <= next_state;
    end
end

assign out = shift_reg; // Continuous assignment to output the current state

endmodule