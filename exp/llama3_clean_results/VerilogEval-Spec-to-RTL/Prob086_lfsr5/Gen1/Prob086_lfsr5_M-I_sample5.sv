module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b00001; // reset to 1
    end else begin
        // Calculate the next state of the MSB
        reg tmp = q_reg[4] ^ q_reg[3] ^ q_reg[0];
        // Shift the remaining bits to the right
        q_reg <= {tmp, q_reg[4:1]};
    end
end

assign q = q_reg;

endmodule