module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        q_reg <= 5'b1; // reset to a non-zero value
    end else begin
        q_reg <= {q_reg[3:0], q_reg[4] ^ q_reg[0]}; // shift right and XOR with LSB
        q_reg[2] <= q_reg[1]; // bit position 2 does not have a tap, so it shifts right
        q_reg[1] <= q_reg[0]; // bit position 1 does not have a tap, so it shifts right
    end
end

assign q = q_reg;

endmodule