module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // asynchronous reset to state B (1)
        state <= 1'b1;
    end else begin
        case (state)
            1'b0: // State A
                case (in)
                    1'b0: state <= 1'b1; // transition from A to B on input 0
                    1'b1: state <= 1'b0; // stay in state A on input 1
                endcase
            1'b1: // State B
                case (in)
                    1'b0: state <= 1'b0; // transition from B to A on input 0
                    1'b1: state <= 1'b1; // stay in state B on input 1
                endcase
        endcase
    end
end

endmodule