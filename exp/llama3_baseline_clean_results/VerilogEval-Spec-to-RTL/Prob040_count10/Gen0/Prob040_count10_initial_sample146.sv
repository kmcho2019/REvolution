module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @ (posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0000; // Reset to 0 when reset is high
    end else if (q_reg == 4'd9) begin
        q_reg <= 4'b0000; // Reset to 0 after reaching 9
    end else begin
        q_reg <= q_reg + 1; // Increment count
    end
end

assign q = q_reg;

endmodule