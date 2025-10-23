module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

// Using always_ff for better timing performance and synthesis
always_ff @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'h34; // Load reset value
    end else begin
        shift_reg <= {shift_reg[6:0], d[7]}; // Shift in new data
    end
end

// Output the current state of the shift register
assign q = shift_reg;

endmodule