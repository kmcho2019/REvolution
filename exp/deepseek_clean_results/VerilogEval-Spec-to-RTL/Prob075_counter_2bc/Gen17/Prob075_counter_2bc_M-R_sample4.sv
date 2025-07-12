module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = 2'b01;  // Async reset value
    end
    else if (train_valid) begin
        case ({train_taken, state})
            3'b0_00: next_state = 2'b00;  // Decrement saturate at 0
            3'b0_01: next_state = 2'b00;
            3'b0_10: next_state = 2'b01;
            3'b0_11: next_state = 2'b10;
            3'b1_00: next_state = 2'b01;  // Increment from 0
            3'b1_01: next_state = 2'b10;
            3'b1_10: next_state = 2'b11;
            3'b1_11: next_state = 2'b11;  // Increment saturate at 3
            default: next_state = state;   // Should never happen
        endcase
    end
    else begin
        next_state = state;  // Hold when not training
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end
    else begin
        state <= next_state;
    end
end

endmodule