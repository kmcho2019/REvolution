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
        case (state)
            2'b00: next_state = train_taken ? 2'b01 : 2'b00;
            2'b01: next_state = train_taken ? 2'b10 : 2'b00;
            2'b10: next_state = train_taken ? 2'b11 : 2'b01;
            2'b11: next_state = train_taken ? 2'b11 : 2'b10;
            default: next_state = 2'b01;
        endcase
    end else begin
        next_state = state;  // Hold current state when not training
    end
end

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else begin
        state <= next_state;
    end
end

endmodule