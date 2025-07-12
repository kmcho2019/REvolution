module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg done_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        if (in[3] && state == 0) begin
            state <= 1;
        end else if (state!= 0 && state < 3) begin
            state <= state + 1;
        end else if (state == 3) begin
            state <= 0;
        end
        done_reg <= (state == 3);
    end
end

assign done = done_reg;

endmodule