module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
    prev_in <= in;
end

always @(*) begin
    out <= out_reg;
end

endmodule