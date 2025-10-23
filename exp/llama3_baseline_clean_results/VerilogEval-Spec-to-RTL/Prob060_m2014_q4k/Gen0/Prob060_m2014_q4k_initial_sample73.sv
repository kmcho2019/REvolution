module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous reset: clear shift register when resetn is low
        shift_reg <= 4'b0000;
    end else begin
        // Shift register operation: shift left and input new value
        shift_reg <= {shift_reg[2:0], in};
    end
end

// Output the last bit of the shift register
assign out = shift_reg[3];

endmodule