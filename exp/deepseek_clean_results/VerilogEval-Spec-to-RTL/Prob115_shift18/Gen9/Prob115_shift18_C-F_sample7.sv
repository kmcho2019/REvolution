module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift operation wires
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Control signals
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_amount = amount[0];

// Next state logic
wire [63:0] next_q = 
    load ? data :                   // Highest priority: load
    do_shift ?                      // Shift when enabled and not loading
        (shift_right ? 
            (shift_amount ? shift_right_8 : shift_right_1) :
            (shift_amount ? shift_left_8  : shift_left_1)) :
    q;                              // Default: hold value

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule