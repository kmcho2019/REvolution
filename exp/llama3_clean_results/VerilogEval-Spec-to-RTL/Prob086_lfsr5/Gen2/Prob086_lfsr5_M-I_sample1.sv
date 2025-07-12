module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg; // internal register for LFSR state

always @(posedge clk) begin
    if (reset) begin
        // reset LFSR output to 1
        q_reg <= 5'b00001;
    end else begin
        // shift right and XOR with LSB at tap positions
        q_reg[4] <= q_reg[3];
        q_reg[3] <= q_reg[2];
        q_reg[2] <= q_reg[1] ^ q_reg[0];
        q_reg[1] <= q_reg[0];
        q_reg[0] <= q_reg[4] ^ q_reg[0];
    end
end

assign q = q_reg; // assign internal register to output

endmodule