module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

// Next state logic based on current state and inputs
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case(state)
            1'b0: begin // OFF state
                if (j == 1'b1) state <= 1'b1; // Transition to ON state if j is high
            end
            1'b1: begin // ON state
                if (k == 1'b1) state <= 1'b0; // Transition to OFF state if k is high
            end
        endcase
    end
end

// Output logic based on current state
always @(state) begin
    case(state)
        1'b0: out = 1'b0; // Output 0 in OFF state
        1'b1: out = 1'b1; // Output 1 in ON state
    endcase
end

endmodule