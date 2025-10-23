module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Register inputs to reduce glitching
reg train_valid_reg, train_taken_reg;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        train_valid_reg <= 1'b0;
        train_taken_reg <= 1'b0;
    end else begin
        train_valid_reg <= train_valid;
        train_taken_reg <= train_taken;
    end
end

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid_reg) begin
        case ({train_taken_reg, state})
            3'b0_00: state <= 2'b00;  // Stay at min
            3'b0_01: state <= 2'b00;
            3'b0_10: state <= 2'b01;
            3'b0_11: state <= 2'b10;
            3'b1_00: state <= 2'b01;  // Increment
            3'b1_01: state <= 2'b10;
            3'b1_10: state <= 2'b11;
            3'b1_11: state <= 2'b11;  // Stay at max
            default: state <= state;
        endcase
    end
end

endmodule