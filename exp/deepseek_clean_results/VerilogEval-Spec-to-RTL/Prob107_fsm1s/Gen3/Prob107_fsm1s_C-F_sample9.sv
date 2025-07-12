module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= state ~^ in;  // XNOR operation
        end
    end

    assign out = ~state;  // Output is inverse of state

endmodule