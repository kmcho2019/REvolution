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
        2'b01: // Decrement when count_ena is 1 and shift_ena is 0
            q_reg <= (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1; 
        2'b10: // Shift when shift_ena is 1 and count_ena is 0
            q_reg <= {data, q_reg[3:1]};
        2'b11: // Handle the case when both shift_ena and count_ena are 1
            // We can either prioritize the shift operation or the decrement operation
            // Here, we prioritize the shift operation
            q_reg <= {data, q_reg[3:1]};
        default: // Hold current value when both shift_ena and count_ena are 0
            q_reg <= q_reg;
    endcase
end

assign q = q_reg;

endmodule