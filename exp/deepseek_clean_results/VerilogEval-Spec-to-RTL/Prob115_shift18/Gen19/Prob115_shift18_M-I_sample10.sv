module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Precompute all possible shift operations in parallel
wire [63:0] left_shift_1  = q << 1;
wire [63:0] left_shift_8  = q << 8;
wire [63:0] right_shift_1 = {q[63], q[63:1]};  // Arithmetic right shift by 1
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};  // Arithmetic right shift by 8

// Hierarchical shift selection
wire [63:0] shift_result;
always @(*) begin
    case (amount)
        2'b00: shift_result = left_shift_1;
        2'b01: shift_result = left_shift_8;
        2'b10: shift_result = right_shift_1;
        2'b11: shift_result = right_shift_8;
    endcase
end

// Clock-gated next state logic
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update with clock gating
always @(posedge clk) begin
    q <= next_q;
end

endmodule