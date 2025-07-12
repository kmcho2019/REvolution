module right_shifter (
    input clk,
    input reset_n,  // Optional active-low reset
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;

// Continuous assignment for output
assign q = shift_reg;

// Shift operation with reset
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 8'b0;
    end
    else begin
        shift_reg <= {d, shift_reg[7:1]};
    end
end

endmodule