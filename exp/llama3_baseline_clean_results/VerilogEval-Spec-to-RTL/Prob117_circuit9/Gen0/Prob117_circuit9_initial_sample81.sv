module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

initial q_reg = 3'b100; // Initialize q_reg to 4

always @(posedge clk) begin
    if (!a) begin
        if (q_reg == 3'b111) begin // If q_reg is 7, wrap around to 0
            q_reg <= 3'b000;
        end else begin
            q_reg <= q_reg + 1'b1;
        end
    end
end

assign q = q_reg;

endmodule