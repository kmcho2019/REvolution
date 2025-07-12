module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 64'd0;
    end else begin
        if (shift_reg[0] == 1'b0) begin
            shift_reg <= {1'b1, shift_reg[63:1]};
        end else begin
            shift_reg <= {1'b0, shift_reg[63:1]};
        end
    end
end

assign Q = shift_reg;

endmodule