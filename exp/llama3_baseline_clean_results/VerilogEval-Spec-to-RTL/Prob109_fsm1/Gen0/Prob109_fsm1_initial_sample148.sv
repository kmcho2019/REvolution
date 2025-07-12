module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // Current state, 0 for A, 1 for B
reg [0:0] next_state; // Next state

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        1'b0: begin // State A
            case (in)
                1'b0: next_state = 1'b1; // A to B on 0 input
                1'b1: next_state = 1'b0; // Stay in A on 1 input
            endcase
        end
        1'b1: begin // State B
            case (in)
                1'b0: next_state = 1'b0; // B to A on 0 input
                1'b1: next_state = 1'b1; // Stay in B on 1 input
            endcase
        end
    endcase
end

// Output logic (Moore machine, output depends only on the current state)
always @(*) begin
    case (state)
        1'b0: out = 1'b0; // Output 0 in state A
        1'b1: out = 1'b1; // Output 1 in state B
    endcase
end

endmodule