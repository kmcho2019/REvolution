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

always @(load, ena, amount, data, q_reg) begin
    case ({ena, amount})
        3'b100: next_q = {q_reg[62:0], 1'b0}; // shift left by 1
        3'b101: next_q = {q_reg[55:0], 8'd0}; // shift left by 8
        3'b110: next_q = {q_reg[63], q_reg[63:1]}; // shift right by 1
        3'b111: next_q = {{8{q_reg[63]}}, q_reg[63:8]}; // shift right by 8
        default: if (load) next_q = data; else next_q = q_reg;
    endcase
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule