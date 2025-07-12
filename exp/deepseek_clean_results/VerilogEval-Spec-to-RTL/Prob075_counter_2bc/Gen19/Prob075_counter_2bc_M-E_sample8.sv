module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Parallel next state computation
wire [1:0] inc_state = state + 1'b1;
wire [1:0] dec_state = state - 1'b1;
wire inc_saturated = &state;    // state == 2'b11
wire dec_saturated = ~|state;   // state == 2'b00

// Next state selection
reg [1:0] next_state;
always @(*) begin
    if (areset) begin
        next_state = 2'b01;
    end else if (train_valid) begin
        case ({train_taken, inc_saturated, dec_saturated})
            3'b100: next_state = inc_state;    // Taken, not saturated
            3'b101: next_state = state;        // Taken, saturated
            3'b010: next_state = dec_state;    // Not taken, not saturated
            3'b011: next_state = state;        // Not taken, saturated
            default: next_state = state;       // Shouldn't occur
        endcase
    end else begin
        next_state = state;    // Hold when not training
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule