module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg = 3'b100; // Initialize q to 4

always @ (posedge clk)
begin
    if (~a) begin
        if (q_reg == 3'b110) begin // If q is 6
            q_reg <= 3'b000; // Wrap around to 0
        end else if (q_reg == 3'b000) begin
            q_reg <= 3'b001; // If q is 0, set to 1
        end else begin
            q_reg <= q_reg + 1; // Increment q
        end
    end
end

assign q = q_reg;

endmodule