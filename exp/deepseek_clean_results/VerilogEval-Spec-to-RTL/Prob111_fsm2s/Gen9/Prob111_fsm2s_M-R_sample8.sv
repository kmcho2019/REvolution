module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    // State register with compact transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else if (state) begin
            state <= ~k;    // ON state: stay ON unless k=1
        end else begin
            state <= j;     // OFF state: go ON if j=1
        end
    end

    // Output remains pure Moore
    assign out = state;

endmodule