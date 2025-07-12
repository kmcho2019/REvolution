module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

// Combinational next state logic
always @(*) begin
    if (train_valid) begin
        case ({train_taken, state})
            3'b000: next_state = 2'b00; // 0, stay at min
            3'b001: next_state = 2'b00; // 0, decrement
            3'b010: next_state = 2'b01; // 0, decrement
            3'b011: next_state = 2'b10; // 0, decrement
            3'b100: next_state = 2'b01; // 1, increment
            3'b101: next_state = 2'b10; // 1, increment
            3'b110: next_state = 2'b11; // 1, increment
            3'b111: next_state = 2'b11; // 1, stay at max
        endcase
    end else begin
        next_state = state; // hold when not training
    end
end

// Sequential state register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule