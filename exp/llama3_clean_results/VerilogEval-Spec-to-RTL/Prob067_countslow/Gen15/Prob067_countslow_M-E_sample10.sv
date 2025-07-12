module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count_reg;
reg [3:0] next_count;

always @(*) begin
    if (count_reg == 4'd9 && slowena) begin
        next_count = 4'd0;
    end else if (slowena) begin
        next_count = count_reg + 1;
    end else begin
        next_count = count_reg;
    end
end

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'd0;
    end else begin
        count_reg <= next_count;
    end
end

assign q = count_reg;

endmodule