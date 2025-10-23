module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Gated control signals
wire do_shift = ena & ~load;
wire shift_left = do_shift & ~amount[1];
wire shift_right = do_shift & amount[1];
wire shift_by_8 = amount[0];

// Parallel shift computation
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Combined shift result
wire [63:0] shift_result = 
    shift_left ? (shift_by_8 ? left_shift_8 : left_shift_1) :
    shift_right ? (shift_by_8 ? right_shift_8 : right_shift_1) :
    q; // Default hold value

// Next state logic with priority to load
wire [63:0] next_q = load ? data : shift_result;

// Clock-gated register update
always @(posedge clk) begin
    if (load || ena) begin
        q <= next_q;
    end
end

endmodule