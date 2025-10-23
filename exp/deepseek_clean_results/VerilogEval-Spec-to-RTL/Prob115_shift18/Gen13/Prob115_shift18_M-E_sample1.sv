module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
wire [3:0] shift_sel = {amount, ena, ~load};
wire [63:0] shifted_val;

// Shift amount decoder
wire shift_left_1  = (shift_sel == 4'b0001);
wire shift_left_8  = (shift_sel == 4'b0101);
wire shift_right_1 = (shift_sel == 4'b1001);
wire shift_right_8 = (shift_sel == 4'b1101);

// Sign extension wires
wire [7:0] sign_byte = {8{q[63]}};

// Barrel shifter implementation
assign shifted_val = 
    shift_left_1  ? {q[62:0], 1'b0} :
    shift_left_8  ? {q[55:0], 8'b0} :
    shift_right_1 ? {q[63], q[63:1]} :
    shift_right_8 ? {sign_byte, q[63:8]} :
    q;

// Register update logic
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_val;
end

endmodule