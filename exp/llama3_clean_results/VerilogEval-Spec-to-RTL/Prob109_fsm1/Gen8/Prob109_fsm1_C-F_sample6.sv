module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to state B
        state <= 1'b1;
    end else begin
        case (state)
            1'b0: // State A
                state <= in ? 1'b0 : 1'b1; // A (0) --0--> B, A (0) --1--> A
            1'b1: // State B
                state <= in ? 1'b1 : 1'b0; // B (1) --0--> A, B (1) --1--> B
            default: state <= 1'b1;
        endcase
    end
end

// Out is directly derived from the state
assign out = state;

endmodule