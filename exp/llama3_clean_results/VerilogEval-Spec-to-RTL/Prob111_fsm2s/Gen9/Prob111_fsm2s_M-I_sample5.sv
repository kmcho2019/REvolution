module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        case(out)
            1'b0: out <= j;
            1'b1: out <= ~k;
        endcase
    end
end

endmodule