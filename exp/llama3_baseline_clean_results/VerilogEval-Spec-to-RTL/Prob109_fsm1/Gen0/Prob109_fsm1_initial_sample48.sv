module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [1:0] state; // 0 for state A, 1 for state B
reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = 1; // Reset to state B
    end else begin
        case (state)
            1'b0: begin // State A
                if (~in) begin
                    next_state = 1; // Transition to state B on in=0
                end else begin
                    next_state = 0; // Stay in state A on in=1
                end
            end
            1'b1: begin // State B
                if (~in) begin
                    next_state = 0; // Transition to state A on in=0
                end else begin
                    next_state = 1; // Stay in state B on in=1
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    state <= next_state;
end

// Since it's a Moore machine, output is determined by the current state
// Based on the given diagram, state B corresponds to output 1 and state A to output 0
always @(state) begin
    case (state)
        1'b0: out <= 0; // Output 0 when in state A
        1'b1: out <= 1; // Output 1 when in state B
    endcase
end

endmodule