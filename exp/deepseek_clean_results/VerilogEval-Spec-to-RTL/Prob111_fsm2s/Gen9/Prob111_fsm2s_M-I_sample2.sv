module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    // Optimized state register with direct transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            state <= (state) ? ~k : j;
        end
    end

    // Output remains pure Moore
    assign out = state;

endmodule