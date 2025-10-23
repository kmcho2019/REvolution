module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(*) begin
    if (areset) begin
        q_reg = 4'b0;
    end else if (clk && load) begin
        q_reg = data;
    end else if (clk && ena && !load) begin
        q_reg = {1'b0, q_reg[3:1]};
    end else if (clk && !ena && !load) begin
        q_reg = q_reg;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= q_reg;
    end
end

endmodule