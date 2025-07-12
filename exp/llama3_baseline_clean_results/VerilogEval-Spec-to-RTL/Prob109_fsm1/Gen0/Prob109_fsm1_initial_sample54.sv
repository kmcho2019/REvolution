module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 0 for A, 1 for B
always @(*) begin
    if (areset) begin
        state = 1; // Reset to state B
    end else begin
        case(state)
            0: state = in ? 0 : 1; // State A transitions
            1: state = in ? 1 : 0; // State B transitions
            default: state = 1; // Default to state B
        endcase
    end
end

// Moore machine output depends only on the state
assign out = state;

endmodule