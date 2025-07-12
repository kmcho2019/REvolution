module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;
        end else if (out) begin
            out <= ~k;  // Stay ON if k=0, go OFF if k=1
        end else begin
            out <= j;   // Stay OFF if j=0, go ON if j=1
        end
    end

endmodule