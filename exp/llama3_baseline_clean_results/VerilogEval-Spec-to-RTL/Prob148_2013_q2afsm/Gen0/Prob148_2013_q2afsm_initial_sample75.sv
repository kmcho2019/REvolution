module TopModule(
    input  clk,
    input  resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // Should go to state D, but we'll stay in state A
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
        default: // State D (should never be reached)
            next_state = 2'b00; // Go back to state A
    endcase
end

// Output logic
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0; // Since we never go to state D

endmodule