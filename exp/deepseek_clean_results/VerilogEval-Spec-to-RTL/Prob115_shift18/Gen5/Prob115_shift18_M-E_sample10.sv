module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results
wire [63:0] left_1, left_8, right_1, right_8;
wire [7:0] sign_ext_8 = {8{q[63]}};  // Pre-extend sign bit for 8-bit right shift

// Shift operations (computed in parallel)
assign left_1  = {q[62:0], 1'b0};
assign left_8  = {q[55:0], 8'b0};
assign right_1 = {q[63], q[63:1]};
assign right_8 = {sign_ext_8, q[63:8]};

// Shift result selection
reg [63:0] shift_result;
always @(*) begin
    case (amount)
        2'b00: shift_result = left_1;
        2'b01: shift_result = left_8;
        2'b10: shift_result = right_1;
        2'b11: shift_result = right_8;
        default: shift_result = q;
    endcase
end

// Next state logic with early enable gating
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule