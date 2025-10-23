module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0001;  // Initial state
    end
    else begin
        // Rotate left with XOR feedback to create counting sequence
        shift_reg <= {shift_reg[2:0], shift_reg[3] ^ shift_reg[1]};
    end
end

assign q = shift_reg;

endmodule