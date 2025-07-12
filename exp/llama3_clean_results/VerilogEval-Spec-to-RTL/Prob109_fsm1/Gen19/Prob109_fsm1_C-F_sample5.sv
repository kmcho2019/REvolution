module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state

// Current state update with combinational logic for next state
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: state <= in ? 1'b0 : 1'b1;
            1'b1: state <= in ? 1'b1 : 1'b0;
        endcase
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule