module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to have only the LSB set
        q_reg <= 5'b00001;
    end else begin
        // Calculate next state
        q_reg[4] <= q_reg[3] ^ q_reg[0]; // Tap at position 5
        q_reg[3] <= q_reg[2];
        q_reg[2] <= q_reg[1] ^ q_reg[0]; // Tap at position 3
        q_reg[1] <= q_reg[0];
        q_reg[0] <= q_reg[4]; // Shift right
    end
end

assign q = q_reg;

endmodule