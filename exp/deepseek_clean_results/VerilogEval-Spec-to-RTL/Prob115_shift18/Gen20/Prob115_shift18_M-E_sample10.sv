module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};

// Arithmetic right shifts with sign extension
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Direction selection
wire [63:0] left_shift_result = amount[0] ? left_shift_8 : left_shift_1;
wire [63:0] right_shift_result = amount[0] ? right_shift_8 : right_shift_1;

// Shift operation selection
wire [63:0] shift_result = amount[1] ? right_shift_result : left_shift_result;

// Final next state logic with enable and load
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule