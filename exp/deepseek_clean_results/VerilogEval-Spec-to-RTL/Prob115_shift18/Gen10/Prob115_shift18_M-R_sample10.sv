module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control signals
wire left_shift = ~amount[1];
wire shift_by_8 = amount[0];

// Left shift options
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};

// Right shift options (arithmetic)
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Shift selection
wire [63:0] shifted_value = 
    left_shift ? 
        (shift_by_8 ? left_shift_8 : left_shift_1) :
        (shift_by_8 ? right_shift_8 : right_shift_1);

// Next value selection
wire [63:0] next_q = load ? data : (ena ? shifted_value : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule