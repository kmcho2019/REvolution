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
        if (state == 1'b0) begin // Currently in state A
            state <= in? 1'b0 : 1'b1; // Stay in A on in=1, go to B on in=0
        end else begin // Currently in state B
            state <= in? 1'b1 : 1'b0; // Stay in B on in=1, go to A on in=0
        end
    end
end

endmodule