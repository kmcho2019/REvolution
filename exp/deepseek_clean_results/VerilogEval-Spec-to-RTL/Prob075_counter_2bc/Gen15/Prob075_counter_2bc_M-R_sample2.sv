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
    if (areset) begin
        next_state = 2'b01;
    end
    else if (train_valid) begin
        case ({train_taken, state})
            3'b000: next_state = 2'b00; // no change at min
            3'b001: next_state = 2'b00; // decrement
            3'b010: next_state = 2'b01; // decrement
            3'b011: next_state = 2'b10; // decrement
            3'b100: next_state = 2'b01; // increment
            3'b101: next_state = 2'b10; // increment
            3'b110: next_state = 2'b11; // increment
            3'b111: next_state = 2'b11; // no change at max
        endcase
    end
    else begin
        next_state = state;
    end
end

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule