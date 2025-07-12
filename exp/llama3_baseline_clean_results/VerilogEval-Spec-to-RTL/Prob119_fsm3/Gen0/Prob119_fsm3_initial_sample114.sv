module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] current_state;
reg [1:0] next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        2'b00: // State A
            if (!in) begin
                next_state = 2'b00; // Stay in A
            end else begin
                next_state = 2'b01; // Move to B
            end
        2'b01: // State B
            if (!in) begin
                next_state = 2'b10; // Move to C
            end else begin
                next_state = 2'b01; // Stay in B
            end
        2'b10: // State C
            if (!in) begin
                next_state = 2'b00; // Move to A
            end else begin
                next_state = 2'b11; // Move to D
            end
        2'b11: // State D
            if (!in) begin
                next_state = 2'b10; // Move to C
            end else begin
                next_state = 2'b01; // Move to B
            end
        default: next_state = 2'b00; // Default to state A
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // Outputs for A, B, C
        2'b11: out = 1'b1; // Output for D
        default: out = 1'b0; // Default output
    endcase
end

endmodule