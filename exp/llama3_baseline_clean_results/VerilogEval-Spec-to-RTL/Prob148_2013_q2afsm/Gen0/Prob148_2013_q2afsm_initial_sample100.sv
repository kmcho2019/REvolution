module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State definition
reg [1:0] current_state;
reg [1:0] next_state;

// Combinational logic for next state
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1) begin
                // Assuming state D is not needed as per the description
                // and the condition for state D seems to be the same as state A.
                // We prioritize based on the given conditions, so state D is effectively ignored.
                next_state = 2'b00; // Stay in A, or consider unreachable
            end else begin
                next_state = 2'b00; // Stay in A if no requests
            end
        2'b01: // State B
            if (r[0] == 1) begin
                next_state = 2'b01; // Stay in B
            end else begin
                next_state = 2'b00; // Go back to A
            end
        2'b10: // State C
            if (r[1] == 1) begin
                next_state = 2'b10; // Stay in C
            end else begin
                next_state = 2'b00; // Go back to A
            end
        default: next_state = 2'b00; // Reset to A for any other state
    endcase
end

// Sequential logic for current state update
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Continuous assignment for outputs
assign g[0] = (current_state == 2'b01); // g0 is 1 in state B
assign g[1] = (current_state == 2'b10); // g1 is 1 in state C
assign g[2] = 1'b0; // g2 is always 0 based on the given description

endmodule