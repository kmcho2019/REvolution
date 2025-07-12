module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

// Corrected tap positions considering 0-indexing
// and assuming tap at 32 is actually meant for MSB (31)
wire tap_31 = q_reg[31];
wire tap_22 = q_reg[22];
wire tap_2 = q_reg[2];
wire tap_1 = q_reg[1];

// Calculate the next state for the MSB
wire next_msb = tap_31 ^ tap_22 ^ tap_2 ^ tap_1;

// Combinatorial logic for next state
reg [31:0] next_state;
assign next_state[31] = next_msb;
assign next_state[30:1] = q_reg[29:0];
assign next_state[0] = q_reg[31]; // Shift in the MSB as the new LSB

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule