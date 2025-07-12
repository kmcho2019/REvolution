module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b11111; // Reset to all ones
    end else begin
        q_reg[4] <= q_reg[3] ^ q_reg[0]; // Tap at position 5
        q_reg[3] <= q_reg[2] ^ q_reg[0]; // Tap at position 3
        q_reg[2] <= q_reg[1];
        q_reg[1] <= q_reg[0];
        q_reg[0] <= 1'b0; // Shift in a 0 from the left
    end
end

assign q = q_reg;

endmodule