module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk) begin
        out <= reset ? 1'b0 : (out ? ~k : j);
    end

endmodule