module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count_reg;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'd0;
    end else if (slowena) begin
        if (count_reg == 4'd9) begin
            count_reg <= 4'd0;
        end else begin
            count_reg <= count_reg + 1;
        end
    end
end

assign q = count_reg;

endmodule