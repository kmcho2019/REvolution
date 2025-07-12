module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @ (posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0001; // Reset to 1
    end else if (q_reg == 10) begin
        q_reg <= 4'b0001; // Wrap around to 1 after 10
    end else begin
        q_reg <= q_reg + 1; // Increment the counter
    end
end

assign q = q_reg;

endmodule