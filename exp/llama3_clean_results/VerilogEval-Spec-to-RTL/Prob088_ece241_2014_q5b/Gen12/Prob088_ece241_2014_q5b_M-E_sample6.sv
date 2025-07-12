module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] shift_reg; // 2-bit shift register

always @(posedge clk or posedge areset) begin
    if(areset) begin
        shift_reg <= 2'b00; // Reset shift register
    end else begin
        shift_reg <= {shift_reg[0], x}; // Shift input value into shift register
    end
end

always @(*) begin
    z = ~(shift_reg[1] ^ x); // Generate output based on current and previous input values
end

endmodule