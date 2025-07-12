module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

reg [1:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        if (in[3]) begin
            state <= 1;
        end else if (state != 0 && state < 3) begin
            state <= state + 1;
        end
        if (state == 3) begin
            state <= 0;
        end
        done <= (state == 3);
    end
end

endmodule