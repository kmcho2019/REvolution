module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

always_latch begin
    if (areset) begin
        state = 1'b1; // asynchronous reset to state B
    end else if (clk) begin
        if (in) begin
            if (state == 1'b0) begin // Currently in state A
                state = 1'b0; // Stay in A
            end else begin // Currently in state B
                state = 1'b1; // Stay in B
            end
        end else begin
            if (state == 1'b0) begin // Currently in state A
                state = 1'b1; // Go to B
            end else begin // Currently in state B
                state = 1'b0; // Go to A
            end
        end
    end
end

endmodule