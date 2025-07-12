module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output g
assign g[0] = (current_state == 2'b01) ? 1'b1 : 1'b0;
assign g[1] = (current_state == 2'b10) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // g[2] is always 0

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2]) begin
                next_state = 2'b00; // Stay in A if no requests
            end else if (r[0]) begin
                next_state = 2'b01; // Go to B if device 0 requests
            end else if (r[1]) begin
                next_state = 2'b10; // Go to C if device 1 requests
            end else if (r[2]) begin
                next_state = 2'b00; // Go to A if device 2 requests
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in B if device 0 still requests
            end else begin
                next_state = 2'b00; // Go back to A if device 0 no longer requests
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in C if device 1 still requests
            end else begin
                next_state = 2'b00; // Go back to A if device 1 no longer requests
            end
        default: // State D (not used)
            next_state = 2'b00; // Go back to A
    endcase
end

endmodule