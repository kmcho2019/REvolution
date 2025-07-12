module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] detected;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        detected <= 32'd0;
        out <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (!in[i] && prev_in[i]) begin
                detected[i] <= 1'b1;
            end
        end
        out <= detected;
    end
end

endmodule