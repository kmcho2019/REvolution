module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign extension bits for arithmetic right shifts
wire [7:0] sign_ext_8 = {8{q[63]}};
wire sign_ext_1 = q[63];

// Shift amount decoder
wire shift_left = ~amount[1];
wire shift_8 = amount[0];

// Left shift options
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};

// Right shift options (arithmetic)
wire [63:0] right_shift_1 = {sign_ext_1, q[63:1]};
wire [63:0] right_shift_8 = {sign_ext_8, q[63:8]};

// Barrel shifter output
wire [63:0] shifted_value = 
    shift_left ? (shift_8 ? left_shift_8 : left_shift_1) :
                 (shift_8 ? right_shift_8 : right_shift_1);

// Next state logic
wire [63:0] next_q = load ? data : (ena ? shifted_value : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule