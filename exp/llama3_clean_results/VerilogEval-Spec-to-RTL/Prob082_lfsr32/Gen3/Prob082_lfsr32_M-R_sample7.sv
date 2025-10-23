module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

// Combinational logic for next state calculation
wire [31:0] q_next;
assign q_next = {q_reg[0] ^ q_reg[1] ^ q_reg[21] ^ q_reg[31], q_reg[31:1]};

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