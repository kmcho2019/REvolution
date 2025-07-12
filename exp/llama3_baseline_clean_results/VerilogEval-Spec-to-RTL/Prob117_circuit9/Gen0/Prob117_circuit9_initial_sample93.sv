module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

always @(posedge clk) begin
    if (a == 1) begin
        q_reg <= 4; // Stay at 4 when a is 1
    end else if (q_reg == 6) begin // Wrap around after 6
        q_reg <= 0;
    end else begin
        q_reg <= q_reg + 1; // Increment when a is 0
    end
end

assign q = q_reg;

endmodule