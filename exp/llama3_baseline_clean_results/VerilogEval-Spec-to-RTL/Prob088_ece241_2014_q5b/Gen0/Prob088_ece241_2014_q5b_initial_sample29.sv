module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] state;
reg [1:0] next_state;

// Output z
assign z = (state == 2'b10) || (state == 2'b01 && x == 1'b1);

// State transitions
always @(*) begin
    case(state)
        2'b01: next_state = (x == 1'b0) ? 2'b01 : 2'b10;
        2'b10: next_state = 2'b10;
        default: next_state = 2'b01; // Invalid state, default to A
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule