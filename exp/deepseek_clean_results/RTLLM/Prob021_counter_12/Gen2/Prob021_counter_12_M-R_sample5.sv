module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output wire [3:0] out
);

reg [3:0] count_reg;

// Continuous assignment for output
assign out = count_reg;

// Counter logic with clock edge trigger
always @(posedge clk) begin
    if (!rst_n) begin
        count_reg <= 4'b0000;
    end else if (valid_count) begin
        count_reg <= (count_reg == 4'd11) ? 4'b0000 : count_reg + 1'b1;
    end
end

endmodule