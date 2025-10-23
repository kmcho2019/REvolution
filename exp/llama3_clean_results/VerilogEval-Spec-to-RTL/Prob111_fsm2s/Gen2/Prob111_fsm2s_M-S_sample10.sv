module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // OFF
        out <= 1'b0;
    end else begin
        if (state == 1'b0) begin // OFF
            if (j == 1'b1) begin
                state <= 1'b1; // ON
                out <= 1'b1;
            end
        end else begin // ON
            if (k == 1'b1) begin
                state <= 1'b0; // OFF
                out <= 1'b0;
            end
        end
    end
end

endmodule