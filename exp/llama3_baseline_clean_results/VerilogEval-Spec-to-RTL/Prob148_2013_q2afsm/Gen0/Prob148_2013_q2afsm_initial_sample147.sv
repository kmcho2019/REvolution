module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State Table
always @(*) begin
    case (state)
        2'b00: // State A
            if (~r[0] && r[1] && ~r[2])
                next_state = 2'b10; // State C
            else if (r[0])
                next_state = 2'b01; // State B
            else if (~r[0] && ~r[1] && r[2])
                next_state = 2'b00; // State A (stays in state A)
            else
                next_state = 2'b00; // State A (stays in state A)
        2'b01: // State B
            if (r[0])
                next_state = 2'b01; // State B
            else
                next_state = 2'b00; // State A
        2'b10: // State C
            if (r[1])
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        default: next_state = 2'b00; // Default state is A
    endcase
end

// State Flip-Flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset state is A
    end else begin
        state <= next_state;
    end
end

// Output Logic
assign g[0] = (state == 2'b01); // g[0] is 1 in state B
assign g[1] = (state == 2'b10); // g[1] is 1 in state C
assign g[2] = 1'b0; // g[2] is always 0

endmodule