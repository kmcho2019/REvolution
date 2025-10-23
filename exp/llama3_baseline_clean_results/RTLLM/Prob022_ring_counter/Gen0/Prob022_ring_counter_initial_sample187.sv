module ring_counter (
    input  logic clk,
    input  logic reset,
    output logic [7:0] out
);

logic [7:0] state, next_state;

// Initialize the ring counter to its starting state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;
    end else begin
        state <= next_state;
    end
end

// Next state logic: shift the '1' bit one position to the right
always_comb begin
    next_state = {state[6:0], state[7]};
end

// Output logic: assign the current state to the output
assign out = state;

endmodule