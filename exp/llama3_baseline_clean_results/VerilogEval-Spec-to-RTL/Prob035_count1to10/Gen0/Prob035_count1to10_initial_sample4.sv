module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0001; // reset to 1 (binary 0001)
    end else if (q_reg == 4'b1001) begin // if counter is at 10 (binary 1001)
        q_reg <= 4'b0001; // wrap around to 1
    end else begin
        q_reg <= q_reg + 1'b1; // increment counter
    end
end

assign q = q_reg;

endmodule