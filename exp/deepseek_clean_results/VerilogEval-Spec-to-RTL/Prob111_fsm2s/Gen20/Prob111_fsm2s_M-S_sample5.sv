module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    always @(posedge clk) state <= reset ? 0 : state ? ~k : j;
    assign out = state;

endmodule