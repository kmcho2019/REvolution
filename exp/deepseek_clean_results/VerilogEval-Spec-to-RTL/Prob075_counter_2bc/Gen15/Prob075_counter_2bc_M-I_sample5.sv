module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding (documentation only)
// 2'b00: Strongly not-taken
// 2'b01: Weakly not-taken (reset state)
// 2'b10: Weakly taken
// 2'b11: Strongly taken

wire [1:0] next_state;

// Optimized combinational next state logic
assign next_state = areset ? 2'b01 :  // Async reset
                   train_valid ? 
                   ((train_taken & ~&state) ? state + 1'b1 :  // Increment if not saturated
                    (~train_taken & |state) ? state - 1'b1 :  // Decrement if not saturated
                    state) :                                  // Hold if saturated
                   state;                                    // Hold when not training

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        state <= next_state;
    end
end

endmodule