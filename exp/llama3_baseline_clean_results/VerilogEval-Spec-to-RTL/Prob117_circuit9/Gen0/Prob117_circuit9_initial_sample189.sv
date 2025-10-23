module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (q_reg == 3'b100) // 4 in decimal
            q_reg <= 3'b000; // reset to 0
        else
            q_reg <= q_reg + 1'b1;
    end else begin
        q_reg <= 3'b100; // set to 4 when a is high
    end
end

assign q = q_reg;

endmodule