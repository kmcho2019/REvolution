module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

// Combinational logic for next state and output
reg next_state;
always @(*) begin
    case (state)
        1'b0: begin
            // Directly use 'j' as next_state to reduce logic
            next_state = j;
            // Simplify output logic
            out = 1'b0;
        end
        1'b1: begin
            // Simplify next_state logic using '~k'
            next_state = ~k;
            // Direct output based on state
            out = 1'b1;
        end
        default: begin
            next_state = 1'b0;
            out = 1'b0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

endmodule