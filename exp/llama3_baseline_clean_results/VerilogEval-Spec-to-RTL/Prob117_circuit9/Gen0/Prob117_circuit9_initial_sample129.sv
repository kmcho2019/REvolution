module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg = 4; // Initialize with the initial value of q

always @(posedge clk) begin
    if (~a) begin // If a is 0, increment q
        if (q_reg == 7) begin
            q_reg <= 0; // Wrap around to 0 after 7
        end else begin
            q_reg <= q_reg + 1;
        end
    end
end

assign q = q_reg;

endmodule