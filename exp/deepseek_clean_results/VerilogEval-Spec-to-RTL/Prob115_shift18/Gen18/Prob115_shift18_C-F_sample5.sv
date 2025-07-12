module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_right = amount[1];
wire shift_by_8 = amount[0];
wire do_shift = ena & ~load;

// Shift operations (computed in parallel)
wire [63:0] left_shift = shift_by_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
wire [63:0] right_shift = shift_by_8 ? {{8{q[63]}}, q[63:8]} : {q[63], q[63:1]};

// Next state logic (gated by do_shift)
wire [63:0] next_q = do_shift ? (shift_right ? right_shift : left_shift) : q;

// Clock-gated register update
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= next_q;
end

endmodule