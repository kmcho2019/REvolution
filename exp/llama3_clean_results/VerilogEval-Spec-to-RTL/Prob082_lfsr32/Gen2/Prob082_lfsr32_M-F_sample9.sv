module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;
wire [31:0] q_next;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

// Calculate the next state by shifting right and applying XOR for taps
assign q_next = {q_reg[22] ^ q_reg[2] ^ q_reg[1] ^ q_reg[0], q_reg[31:1]};

endmodule