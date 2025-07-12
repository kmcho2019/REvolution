module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        count_reg <= 16'd0;
    end else begin
        if (up_down) begin
            count_reg <= count_reg + 1;
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg;

endmodule