module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        case (state)
            2'b00: state <= train_taken? 2'b01 : 2'b00; // Transition to state 1 or stay at state 0
            2'b01: state <= train_taken? 2'b10 : 2'b00; // Transition to state 2 or state 0
            2'b10: state <= train_taken? 2'b11 : 2'b01; // Transition to state 3 or state 1
            2'b11: state <= train_taken? 2'b11 : 2'b10; // Stay at state 3 or transition to state 2
            default: state <= 2'b01; // Default to state 1
        endcase
    end else begin
        // When train_valid is low, stay in the current state
        state <= state;
    end
end

endmodule