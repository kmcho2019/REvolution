module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0001; // reset to 1
    end else if (q_reg == 4'b1010) begin // count equals 10
        q_reg <= 4'b0001; // wrap around to 1
    end else begin
        q_reg <= q_reg + 4'b0001; // increment counter
    end
end

assign q = q_reg;

endmodule