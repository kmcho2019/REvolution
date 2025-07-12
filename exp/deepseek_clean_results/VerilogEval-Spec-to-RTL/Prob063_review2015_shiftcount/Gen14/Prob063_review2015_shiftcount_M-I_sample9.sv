module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    casez ({shift_ena, count_ena})
        2'b1?: q_reg <= {q_reg[2:0], data};  // Shift has priority
        2'b01: q_reg <= q_reg - 1'b1;        // Count operation
        default: q_reg <= q_reg;              // Hold state
    endcase
end

assign q = q_reg;

endmodule