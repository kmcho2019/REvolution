module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Outputs
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // This state was not actually defined in the FSM, but it can be included for completeness.

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // State A
            end else begin
                next_state = 2'b00; // Stay in State A
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in State B
            end else begin
                next_state = 2'b00; // Go back to State A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in State C
            end else begin
                next_state = 2'b00; // Go back to State A
            end
        default: // Should not happen
            next_state = 2'b00;
    endcase
end

endmodule