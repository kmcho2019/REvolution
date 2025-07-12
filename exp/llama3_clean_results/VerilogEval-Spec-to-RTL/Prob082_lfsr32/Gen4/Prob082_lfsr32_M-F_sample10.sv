module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

// Combinational logic for next state calculation
wire [31:0] q_next;
assign q_next = {q_reg[0] ^ q_reg[1] ^ q_reg[21] ^ q_reg[31], q_reg[31:1]};

// However, to correctly implement the Galois LFSR, we should directly express the XOR for the new MSB and shift the rest
assign q_next = {(q_reg[0] ^ q_reg[1] ^ q_reg[21] ^ q_reg[31]), q_reg[31:1]};

// However, a more correct and simplified version should directly express the operation for each bit position
// The new MSB is the XOR result, and the rest are shifted
assign q_next[31] = q_reg[0] ^ q_reg[1] ^ q_reg[21] ^ q_reg[31];
assign q_next[30:0] = q_reg[31:1];

// Sequential logic for updating q_reg
always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= q_next;
    end
end

// Output assignment
assign q = q_reg;

endmodule