module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

always @(posedge clk) begin
    q_reg[7] <= d;
    q_reg[6] <= q_reg[7];
    q_reg[5] <= q_reg[6];
    q_reg[4] <= q_reg[5];
    q_reg[3] <= q_reg[4];
    q_reg[2] <= q_reg[3];
    q_reg[1] <= q_reg[2];
    q_reg[0] <= q_reg[1];
end

assign q = q_reg;

endmodule