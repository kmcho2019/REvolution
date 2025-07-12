module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg; // internal register to hold the LFSR state
assign q = q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the LFSR output to 1 after reset
        q_reg <= 5'b10000;
    end else begin
        // Shift right and XOR at tap positions
        q_reg <= {q_reg[3] ^ q_reg[0], q_reg[4:1]};
    end
end

endmodule