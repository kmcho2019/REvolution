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
        state <= 1'b1; // asynchronous reset to state B
    end else begin
        case ({state, in}) // Use a 2-bit vector for the LUT index
            2'b00: state <= 1'b1; // From A (0) with in=0, go to B
            2'b01: state <= 1'b0; // From A (0) with in=1, stay in A
            2'b10: state <= 1'b0; // From B (1) with in=0, go to A
            2'b11: state <= 1'b1; // From B (1) with in=1, stay in B
        endcase
    end
end

endmodule