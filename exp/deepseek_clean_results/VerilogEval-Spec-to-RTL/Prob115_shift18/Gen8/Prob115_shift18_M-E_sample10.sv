module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control decoding
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_major = amount[0];  // 1=8-bit, 0=1-bit

// First stage: Major shift (0 or 8 bits)
wire [63:0] stage1_shifted = 
    shift_major ? 
        (shift_right ? {{8{q[63]}}, q[63:8]} : {q[55:0], 8'b0}) : 
        q;

// Second stage: Minor shift (0 or 1 bit)
wire [63:0] stage2_shifted = 
    shift_right ? 
        {{1{stage1_shifted[63]}}, stage1_shifted[63:1]} : 
        {stage1_shifted[62:0], 1'b0};

// Combined shift result
wire [63:0] shifted_value = do_shift ? stage2_shifted : q;

// Next state logic
always @(posedge clk) begin
    q <= load ? data : shifted_value;
end

endmodule