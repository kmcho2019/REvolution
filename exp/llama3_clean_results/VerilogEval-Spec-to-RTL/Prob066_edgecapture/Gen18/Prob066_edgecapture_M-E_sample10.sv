module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] previous_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        previous_in <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (previous_in[i] == 1'b1 && in[i] == 1'b0) begin
                out[i] <= 1'b1;
            end
        end
        previous_in <= in;
    end
end

endmodule