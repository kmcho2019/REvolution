module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    always @(posedge clk) begin
        state <= reset ? 0 : (state ? ~k : j);
    end

    assign out = state;

endmodule