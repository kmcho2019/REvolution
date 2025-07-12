module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state; // Current state
reg [1:0] next_state; // Next state

// State table
always @(*) begin
    case(state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // Stay in state A for r2
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in state B
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in state C
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        default: next_state = 2'b00; // Default to state A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == 2'b01); // g0 is 1 in state B
assign g[1] = (state == 2'b10); // g1 is 1 in state C
assign g[2] = 1'b0; // g2 is always 0 based on the state diagram

endmodule