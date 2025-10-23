module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken on reset
    end else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases (if not already at max)
            3'b1_00: state <= 2'b01;
            3'b1_01: state <= 2'b10;
            3'b1_10: state <= 2'b11;
            // Decrement cases (if not already at min)
            3'b0_01: state <= 2'b00;
            3'b0_10: state <= 2'b01;
            3'b0_11: state <= 2'b10;
            // Default: maintain state when at min/max
            default: state <= state;
        endcase
    end
    // Implicit else: maintain state when train_valid=0
end

endmodule