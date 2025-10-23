module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset) state <= 0;
        else case (state)
            0: state <= j;
            1: state <= ~k;
        endcase
    end

    assign out = state;
endmodule