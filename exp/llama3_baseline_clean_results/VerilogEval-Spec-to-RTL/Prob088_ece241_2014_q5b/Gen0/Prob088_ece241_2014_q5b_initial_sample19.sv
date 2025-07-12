module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // Current state
reg [1:0] next_state; // Next state

// Output logic
assign z = (state == 2'b10 && x == 1'b1) || (state == 2'b01 && x == 1'b0);

// Next state logic
always @(*) begin
    case(state)
        2'b10: next_state = x ? 2'b01 : 2'b10;
        2'b01: next_state = 2'b01;
        default: next_state = 2'b10; // Reset state
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule