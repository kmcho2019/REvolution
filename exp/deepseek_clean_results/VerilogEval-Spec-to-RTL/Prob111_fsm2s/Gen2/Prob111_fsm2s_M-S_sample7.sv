module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset)
            state <= 0;
        else
            state <= state ? (k ? 0 : 1) : (j ? 1 : 0);
    end

    assign out = state;

endmodule