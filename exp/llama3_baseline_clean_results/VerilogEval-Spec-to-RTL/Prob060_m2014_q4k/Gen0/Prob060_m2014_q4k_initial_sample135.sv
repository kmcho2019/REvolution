module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        // Synchronous active-low reset
        shift_reg <= 4'd0;
    end else begin
        // Shift register operation
        shift_reg <= {shift_reg[2:0], in};
    end
end

// Output is the MSB of the shift register
assign out = shift_reg[3];

endmodule