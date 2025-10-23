module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], d[7]};  // Shift left and insert MSB
        shift_reg[7] <= d[7];                 // Maintain parallel load behavior
    end
end

assign q = shift_reg;

endmodule