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
            state <= 0;
        end else begin
            state <= state ? ~k : j;
        end
    end

    assign out = state;

endmodule