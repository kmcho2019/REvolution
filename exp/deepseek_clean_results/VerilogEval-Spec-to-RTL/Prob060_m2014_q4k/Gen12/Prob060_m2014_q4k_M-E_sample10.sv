module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // 4-bit shift register
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;  // Synchronous reset
        end else begin
            // Shift operation with new input at LSB
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    // Output is the MSB of the shift register
    assign out = shift_reg[3];

endmodule