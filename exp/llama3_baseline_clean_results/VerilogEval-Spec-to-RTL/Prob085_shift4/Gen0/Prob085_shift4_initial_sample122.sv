module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

assign q = q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0000;
    end else if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= {1'b0, q_reg[3:1]};
    end
end

endmodule