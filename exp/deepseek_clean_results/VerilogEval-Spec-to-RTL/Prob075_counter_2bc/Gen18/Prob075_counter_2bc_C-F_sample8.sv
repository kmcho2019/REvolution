module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Optimized combinational logic
assign next_state = areset ? 2'b01 :          // Async reset
                   train_valid ? 
                       (train_taken ? 
                           (state[1] & state[0] ? state : state + 1) :  // Increment with saturation at 3
                           (~|state ? state : state - 1)) :             // Decrement with saturation at 0
                   state;

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule