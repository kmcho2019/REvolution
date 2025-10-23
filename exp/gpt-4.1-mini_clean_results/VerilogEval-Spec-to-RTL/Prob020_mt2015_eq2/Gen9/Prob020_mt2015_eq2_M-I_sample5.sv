module TopModule (
    input         clk,
    input         rst_n,
    input  [1:0]  A,
    input  [1:0]  B,
    output        z
);

reg [1:0] A_reg, B_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        A_reg <= 2'b0;
        B_reg <= 2'b0;
    end else begin
        A_reg <= A;
        B_reg <= B;
    end
end

assign z = (A_reg == B_reg);

endmodule