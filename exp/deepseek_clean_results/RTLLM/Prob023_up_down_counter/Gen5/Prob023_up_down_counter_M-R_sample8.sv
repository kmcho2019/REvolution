module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;

// Combinational output assignment
assign count = count_reg;

// Sequential logic for counter update
always @(posedge clk) begin
    if (reset) begin
        count_reg <= 16'b0;
    end else begin
        if (up_down) begin
            count_reg <= count_reg + 1'b1;
        end else begin
            count_reg <= count_reg - 1'b1;
        end
    end
end

endmodule