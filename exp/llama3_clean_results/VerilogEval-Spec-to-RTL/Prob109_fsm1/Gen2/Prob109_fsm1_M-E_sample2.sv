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
        case ({state, in})
            2'b00: state <= 1'b1; // A, 0 -> B
            2'b01: state <= 1'b0; // A, 1 -> A
            2'b10: state <= 1'b0; // B, 0 -> A
            2'b11: state <= 1'b1; // B, 1 -> B
        endcase
    end
end

endmodule