module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] lfsr_reg;
wire [4:0] lfsr_next;

assign lfsr_next = {lfsr_reg[4] ^ lfsr_reg[2] ^ lfsr_reg[0], lfsr_reg[4:1]};

always @(posedge clk) begin
    if (reset) begin
        lfsr_reg <= 5'b00001; // Reset the LFSR to have the LSB set to 1
    end else begin
        lfsr_reg <= lfsr_next; // Update the LFSR state
    end
end

assign q = lfsr_reg;

endmodule