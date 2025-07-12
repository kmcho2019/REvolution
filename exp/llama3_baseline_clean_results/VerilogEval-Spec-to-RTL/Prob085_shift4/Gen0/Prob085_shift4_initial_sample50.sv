module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= {q_reg[2:0], 1'b0};
    end
end

assign q = q_reg;

endmodule