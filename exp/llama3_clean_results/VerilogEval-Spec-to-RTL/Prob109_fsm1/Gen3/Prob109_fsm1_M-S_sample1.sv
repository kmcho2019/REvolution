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
        if (state == 1'b0) begin // current state is A
            if (in == 1'b0) begin
                state <= 1'b1; // A, 0 -> B
            end else begin
                state <= 1'b0; // A, 1 -> A
            end
        end else begin // current state is B
            if (in == 1'b0) begin
                state <= 1'b0; // B, 0 -> A
            end else begin
                state <= 1'b1; // B, 1 -> B
            end
        end
    end
end

endmodule