module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg = 32'h1;

// Calculate the new MSB by XORing the tapped bits with the LSB
wire new_msb;
assign new_msb = q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0];

// Calculate the next state
wire [31:0] next_state;
assign next_state = {new_msb, q_reg[30:0]};

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule