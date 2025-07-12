// Module to reverse the bit ordering of an 8-bit input using a shift register
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out, // 8-bit output vector
    input       clk, // Clock signal
    input       rst  // Reset signal
);

    reg [7:0] shift_reg; // Internal shift register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the shift register
            shift_reg <= 8'b0;
        end else begin
            // Shift the input bits into the register
            shift_reg <= {in[0], shift_reg[7:1]};
        end
    end

    // After 8 clock cycles, the output vector is ready
    always @(posedge clk) begin
        if (clk) begin
            out <= shift_reg;
        end
    end

endmodule