module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal to keep track of the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: // State A
                state <= in ? 1'b0 : 1'b1; // A (0) --1--> A, A (0) --0--> B
            1'b1: // State B
                state <= in ? 1'b1 : 1'b0; // B (1) --1--> B, B (1) --0--> A
            default: state <= 1'b1;
        endcase
    end
end

// Out is derived directly from the state in a Moore machine
assign out = state;

endmodule