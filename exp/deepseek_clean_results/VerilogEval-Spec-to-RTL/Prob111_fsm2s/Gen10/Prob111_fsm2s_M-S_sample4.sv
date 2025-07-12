module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            state <= state ? ~k : j;  // ON->~k, OFF->j
        end
    end

    assign out = state;

endmodule