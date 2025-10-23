module TopModule (
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg; // Internal register to hold the current state

// Assign output q to the internal register
assign q = q_reg;

always @ (posedge clk) begin
    if (reset) begin // Reset is active high
        q_reg <= 32'h1; // Reset to 32'h1
    end else begin
        // Calculate the next state of the LFSR
        q_reg <= {q_reg[30:0], (q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0])};
    end
end

endmodule