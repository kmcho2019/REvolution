module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg clk_enable;

always @(posedge clk) begin
    if (load || ena!= 2'b00) begin
        clk_enable <= 1'b1;
    end else begin
        clk_enable <= 1'b0;
    end
end

always @(posedge clk) begin
    if (clk_enable) begin
        if (load) begin
            q_reg <= data;
        end else begin
            case (ena)
                2'b01: q_reg <= {q_reg[0], q_reg[99:1]};
                2'b10: q_reg <= {q_reg[98:0], q_reg[99]};
                default: q_reg <= q_reg;
            endcase
        end
    end
end

assign q = q_reg;

endmodule