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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else if (train_valid) begin
        case ({train_taken, state})
            3'b0_00: state <= 2'b00;  // Already min, no change
            3'b0_01: state <= 2'b00;  // Decrement
            3'b0_10: state <= 2'b01;  // Decrement
            3'b0_11: state <= 2'b10;  // Decrement
            3'b1_00: state <= 2'b01;  // Increment
            3'b1_01: state <= 2'b10;  // Increment
            3'b1_10: state <= 2'b11;  // Increment
            3'b1_11: state <= 2'b11;  // Already max, no change
        endcase
    end
    // Else hold state when not training
end

endmodule