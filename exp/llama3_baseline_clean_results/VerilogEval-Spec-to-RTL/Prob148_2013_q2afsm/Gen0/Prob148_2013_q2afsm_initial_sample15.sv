module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State flip-flops
always @ (posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @ (*) begin
    case (state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2]) begin
                next_state = 2'b00;
            end else if (r[0]) begin
                next_state = 2'b01; // State B
            end else if (r[1]) begin
                next_state = 2'b10; // State C
            end else if (r[2]) begin
                next_state = 2'b11; // State D
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00; // State A
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00; // State A
            end
        2'b11: // State D
            // Since D doesn't have any outgoing transitions, it's not needed
            next_state = 2'b00; // State A
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

// Outputs
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 0; // g[2] is not needed

endmodule