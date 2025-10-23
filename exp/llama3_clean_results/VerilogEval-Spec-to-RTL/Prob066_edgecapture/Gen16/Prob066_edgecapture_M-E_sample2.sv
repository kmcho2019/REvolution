module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] d1;
reg [31:0] d2;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        d1 <= 32'd0;
        d2 <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        d2 <= d1;
        d1 <= in;
        
        for (int i = 0; i < 32; i++) begin
            if (d2[i] && !d1[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

always @(*) begin
    out = out_reg;
end

endmodule