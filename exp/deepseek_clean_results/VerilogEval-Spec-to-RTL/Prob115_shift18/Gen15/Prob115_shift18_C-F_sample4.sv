module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_by_8 = amount[0];

// Shift operations (computed in parallel)
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Next state logic with gating
wire [63:0] next_shift = shift_right ? 
                        (shift_by_8 ? right_shift_8 : right_shift_1) :
                        (shift_by_8 ? left_shift_8 : left_shift_1);
wire [63:0] next_q = load ? data : (do_shift ? next_shift : q);

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule