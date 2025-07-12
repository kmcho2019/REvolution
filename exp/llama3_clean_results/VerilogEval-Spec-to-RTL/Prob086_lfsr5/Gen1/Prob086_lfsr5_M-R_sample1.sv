module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;
wire next_bit;

assign next_bit = q_reg[4] ^ q_reg[2]; // XOR bits at positions 5 and 3

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b00001; // reset to 1
    end else begin
        q_reg <= {next_bit, q_reg[4:1]}; // shift right and update MSB
    end
end

assign q = q_reg;

endmodule