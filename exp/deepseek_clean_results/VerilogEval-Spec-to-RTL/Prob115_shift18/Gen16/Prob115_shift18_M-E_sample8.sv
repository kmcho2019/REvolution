module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign bit storage for arithmetic right shifts
reg sign_bit;
always @(posedge clk) begin
    if (load) sign_bit <= data[63];
    else if (ena & amount[1]) sign_bit <= q[63]; // Update sign bit on right shifts
end

// Shift direction selection (computed only when needed)
wire [63:0] shift_out;
wire do_shift = ena & ~load;
wire shift_right = amount[1];

// Right shift logic with pre-computed sign extension
wire [63:0] right_shift_result = 
    amount[0] ? {{8{sign_bit}}, q[63:8]} : // Right by 8
                {sign_bit, q[63:1]};      // Right by 1

// Left shift logic
wire [63:0] left_shift_result = 
    amount[0] ? {q[55:0], 8'b0} : // Left by 8
                {q[62:0], 1'b0};  // Left by 1

// Staged computation: direction first, then amount
assign shift_out = shift_right ? right_shift_result : left_shift_result;

// Next state logic with clear priority
wire [63:0] next_q = load ? data : (do_shift ? shift_out : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule