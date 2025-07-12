module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Combinational logic for next state
assign next_state = 
    (train_valid & train_taken) ? (state + {1'b0, ~(&state)}) :  // Increment if not saturated
    (train_valid & ~train_taken) ? (state - {1'b0, |state}) :    // Decrement if not zero
    state;                                                       // Hold otherwise

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;  // Reset to weakly not-taken
    else
        state <= next_state;
end

endmodule