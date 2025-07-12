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
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]}; // Sign-extended right shift

// Shift selection
wire [63:0] shifted_value = 
    load ? data :                   // Load has highest priority
    !ena ? q :                      // No shift when not enabled
    amount[1] ?                     // Right shift if amount[1] is set
        (amount[0] ? shift_right_8 : shift_right_1) :
        (amount[0] ? shift_left_8  : shift_left_1);

// Register update
always @(posedge clk) begin
    q <= shifted_value;
end

endmodule