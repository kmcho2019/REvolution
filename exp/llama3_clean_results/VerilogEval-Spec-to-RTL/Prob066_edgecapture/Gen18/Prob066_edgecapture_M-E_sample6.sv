module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] detected;

always @(posedge clk) begin
    if (reset) begin
        detected <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (!in[i] && (in[i]!= detected[i])) begin
                detected[i] <= 1'b1;
            end
        end
    end
end

always @(*) begin
    out = in | detected;
end

endmodule