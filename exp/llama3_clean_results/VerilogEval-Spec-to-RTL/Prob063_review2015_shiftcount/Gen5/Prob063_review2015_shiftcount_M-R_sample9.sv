module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [3:0] next_q;

always @(*) begin
    case ({shift_ena, count_ena})
        2'b01: next_q = (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1; // Decrement
        2'b10: next_q = {data, q_reg[3:1]}; // Shift
        default: next_q = q_reg; // Hold current value
    endcase
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule