module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (out[i] == 0 && in[i] == 0 && out[i - 1] == 1) begin // Changed condition, consider previous bit if current bit is zero
                out[i] <= 1'b1;
            end else if (out[i] == 0 && in[i - 1] == 1 && in[i] == 0) begin // If current bit is zero and previous bit in input is 1 and current bit is 0
                out[i] <= 1'b1;
            end
        end
    end
end

endmodule