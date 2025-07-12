module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases (train_taken=1, not at max)
            3'b100: state <= 2'b01;
            3'b101: state <= 2'b10;
            3'b110: state <= 2'b11;
            3'b111: state <= 2'b11;  // Saturate at max
            // Decrement cases (train_taken=0, not at min)
            3'b001: state <= 2'b00;
            3'b010: state <= 2'b01;
            3'b011: state <= 2'b10;
            3'b000: state <= 2'b00;  // Saturate at min
            default: state <= state; // Shouldn't happen
        endcase
    end
    // Else state maintains its value
end

endmodule