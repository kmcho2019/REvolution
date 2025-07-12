module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {d, 8'b0}; // Shift input data into the register
    q <= shift_reg[7:0];    // Assign the register value to output
end

endmodule