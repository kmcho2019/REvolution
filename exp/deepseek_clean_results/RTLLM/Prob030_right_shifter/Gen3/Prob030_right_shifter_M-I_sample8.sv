module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;
reg d_reg;  // Registered input
wire [7:0] next_val;

// Register input to break timing path
always @(posedge clk) begin
    d_reg <= d;
end

// Shift operation with registered input
assign next_val = {d_reg, shift_reg[7:1]};

// Main shift register
always @(posedge clk) begin
    shift_reg <= next_val;
end

// Output assignment
assign q = shift_reg;

// Initialization
initial begin
    shift_reg = 8'b0;
    d_reg = 1'b0;
end

endmodule