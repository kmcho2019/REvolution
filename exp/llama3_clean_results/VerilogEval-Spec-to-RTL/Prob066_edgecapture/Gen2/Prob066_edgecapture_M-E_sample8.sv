module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] flag_reg;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
        flag_reg <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if ((prev_in[i] == 1'b1) && (in[i] == 1'b0)) begin
                flag_reg[i] <= 1'b1;
            end
        end
        prev_in <= in;
        out <= flag_reg;
    end
end

endmodule