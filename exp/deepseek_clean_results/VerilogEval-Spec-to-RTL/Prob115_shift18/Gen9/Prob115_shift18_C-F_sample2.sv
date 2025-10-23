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
wire shift_8 = amount[0];

// Shared sign extension for right shifts
wire [7:0] sign_ext = {8{q[63]}};

// Pre-compute all shift options
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {sign_ext, q[63:8]};

// Select shift operation
wire [63:0] shifted_value = 
    shift_right ? (shift_8 ? right_shift_8 : right_shift_1) :
                  (shift_8 ? left_shift_8 : left_shift_1);

// Gated next state logic
wire [63:0] next_q = load ? data : (do_shift ? shifted_value : q);

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule