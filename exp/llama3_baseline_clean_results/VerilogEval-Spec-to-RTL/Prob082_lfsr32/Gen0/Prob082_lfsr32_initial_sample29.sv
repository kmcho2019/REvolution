module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg; // Register to store the current state of the LFSR

// Initialize the LFSR to 32'h1 on reset
always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        // Calculate the next state based on the current state and tap positions
        q_reg <= {q_reg[30:0], q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0]};
    end
end

// Assign the current state to the output
assign q = q_reg;

endmodule