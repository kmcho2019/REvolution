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
            state <= 1'b0;
        end else if (state) begin
            state <= ~k;  // ON state: k=1 goes to OFF, k=0 stays ON
        end else begin
            state <= j;    // OFF state: j=1 goes to ON, j=0 stays OFF
        end
    end

    assign out = state;

endmodule