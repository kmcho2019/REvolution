module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output [3:0] out
);

reg [3:0] out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_reg <= 4'b0000;
    end else if (valid_count) begin
        if (out_reg == 4'd11) begin
            out_reg <= 4'b0000;
        end else begin
            out_reg <= out_reg + 1;
        end
    end
end

assign out = out_reg;

endmodule