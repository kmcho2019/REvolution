module TopModule (
    input clk,
    input in,
    output out
);

    reg [1:0] shift_reg;  // 2-bit shift register for feedback delay

    always @(posedge clk) begin
        shift_reg <= {shift_reg[0], in ^ shift_reg[1]};
    end

    assign out = shift_reg[0];

endmodule