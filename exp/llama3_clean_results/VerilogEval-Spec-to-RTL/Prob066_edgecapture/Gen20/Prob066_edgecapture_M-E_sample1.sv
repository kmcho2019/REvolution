module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out[i] <= 1'b1; // Set the output bit if a falling edge is detected
            end
        end
    end
end

endmodule