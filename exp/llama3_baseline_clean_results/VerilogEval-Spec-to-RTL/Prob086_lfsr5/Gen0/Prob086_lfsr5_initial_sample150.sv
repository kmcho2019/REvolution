module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

initial q_reg = 5'b00001; // initial state with LSB set to 1

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b00001; // reset to initial state
    end else begin
        q_reg <= {q_reg[3] ^ q_reg[1] ^ q_reg[0], q_reg[4:1]}; // Galois LFSR formula
    end
end

assign q = q_reg;

endmodule