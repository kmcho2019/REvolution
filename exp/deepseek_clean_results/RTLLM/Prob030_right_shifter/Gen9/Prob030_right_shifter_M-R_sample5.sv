module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Clock gating control
    output wire [7:0] q
);

// Clock gating
wire gated_clk;
assign gated_clk = clk & enable;

// Internal register
reg [7:0] shift_reg;

// Next state logic (combinational)
wire [7:0] next_shift;
assign next_shift = {d, shift_reg[7:1]};

// Sequential logic (state storage)
always @(posedge gated_clk) begin
    shift_reg <= next_shift;
end

// Output assignment
assign q = shift_reg;

endmodule