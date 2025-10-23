module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
wire [63:0] next_q;

always_comb begin
    case ({ena, amount})
        4'b1000: next_q = {q_reg[62:0], 1'b0}; // shift left by 1 bit
        4'b1001: next_q = {q_reg[55:0], 8'd0}; // shift left by 8 bits
        4'b1010: next_q = {q_reg[63], q_reg[63:1]}; // shift right by 1 bit
        4'b1011: next_q = {{8{q_reg[63]}}, q_reg[63:8]}; // shift right by 8 bits
        4'b1100: next_q = data; // load
        default: next_q = q_reg;
    endcase
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule