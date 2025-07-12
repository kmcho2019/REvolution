module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b10000; // Reset the LFSR to have the MSB set to 1
    end else begin
        q_reg <= {q_reg[4] ^ q_reg[2] ^ q_reg[0], q_reg[3:0]}; // Calculate new MSB and shift
    end
end

assign q = q_reg;

endmodule