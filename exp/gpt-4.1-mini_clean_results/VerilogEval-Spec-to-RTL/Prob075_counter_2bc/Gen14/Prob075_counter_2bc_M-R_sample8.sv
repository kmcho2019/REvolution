module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

wire [1:0] incremented;
wire [1:0] decremented;
wire [1:0] next_state_arith;

// Saturate increment: if state is 3, stay 3; else state + 1
assign incremented = (state == 2'd3) ? 2'd3 : (state + 2'd1);
// Saturate decrement: if state is 0, stay 0; else state - 1
assign decremented = (state == 2'd0) ? 2'd0 : (state - 2'd1);

// Select next state based on train_valid and train_taken
assign next_state_arith = (!train_valid) ? state :
                          (train_taken) ? incremented : decremented;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // weakly not-taken
    else
        state <= next_state_arith;
end

endmodule