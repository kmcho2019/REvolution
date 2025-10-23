module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b01: q_reg <= (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1; // Decrement
        2'b10: q_reg <= {data, q_reg[3:1]}; // Shift
        default: ; // Hold current value
    endcase
end

assign q = q_reg;

endmodule