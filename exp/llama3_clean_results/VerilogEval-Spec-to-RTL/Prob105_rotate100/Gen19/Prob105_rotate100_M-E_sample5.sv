module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Barrel shifter for 100-bit rotator
wire [99:0] rot_right;
wire [99:0] rot_left;

// Right rotation
assign rot_right[0] = q_reg[99];
assign rot_right[99:1] = q_reg[98:0];

// Left rotation
assign rot_left[99] = q_reg[0];
assign rot_left[98:0] = q_reg[99:1];

// Output selection
assign q = (ena == 2'b01) ? rot_right :
           (ena == 2'b10) ? rot_left :
           q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // No need to explicitly update q_reg here, as q is driven by the comb logic
    end
end

endmodule