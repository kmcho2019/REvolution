module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(negedge clk) begin
    if (reset) begin
        // Load the reset value into the shift register
        shift_reg <= 8'd52;
    end else begin
        // Load the input value into the shift register
        shift_reg <= d;
    end
end

// Assign the shift register to the output
assign q = shift_reg;

endmodule