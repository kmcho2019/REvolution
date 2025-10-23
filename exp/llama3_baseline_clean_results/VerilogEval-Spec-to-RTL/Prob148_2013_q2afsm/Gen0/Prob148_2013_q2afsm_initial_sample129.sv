module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State flip-flop
always @(posedge clk) begin
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
            if (r[0]) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1]) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2]) begin
                next_state = 2'b11; // Go to state D
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in state B
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in state C
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        2'b11: // State D
            // This state is not defined in the problem, but we need to handle it
            // We will go back to state A
            next_state = 2'b00; 
        default:
            next_state = 2'b00;
    endcase
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // g2 is not defined in the problem

endmodule