module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Optimized next state logic
assign next_state = areset ? 2'b01 :  // Async reset
                   train_valid ? 
                       (train_taken ? 
                           (state[1] & state[0] ? state : state + 1) :  // Increment with MSB saturation check
                           (~|state ? state : state - 1)                // Decrement with zero check
                       ) : state;                                      // Hold when not training

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else begin
        state <= next_state;
    end
end

endmodule