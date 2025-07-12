module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else if (state) begin
            state <= ~k;  // ON -> OFF if k=1
        end else begin
            state <= j;    // OFF -> ON if j=1
        end
    end

    assign out = state;

endmodule