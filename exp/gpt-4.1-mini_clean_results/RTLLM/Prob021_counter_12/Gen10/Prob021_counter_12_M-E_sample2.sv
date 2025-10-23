module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] count_reg;
reg [3:0] next_count;

always @(*) begin
    if (valid_count) begin
        if (count_reg == 4'd11)
            next_count = 4'd0;
        else
            next_count = count_reg + 1'b1;
    end else begin
        next_count = count_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count_reg <= 4'd0;
    else
        count_reg <= next_count;
end

always @(*) begin
    out = count_reg;
end

endmodule