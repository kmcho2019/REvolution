module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shared sign extension calculation
wire sign_bit = q[63];
wire [7:0] sign_ext = {8{sign_bit}};

// Shift control decoding
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Shift computation (activated only when ena is high)
wire [63:0] shifted_value;
assign shifted_value = (ena) ? 
    (shift_right ? 
        (shift_8 ? {sign_ext, q[63:8]} :  // Right 8 (arithmetic)
                  {sign_bit, q[63:1]}) :  // Right 1 (arithmetic)
        (shift_8 ? {q[55:0], 8'b0} :     // Left 8
                  {q[62:0], 1'b0})        // Left 1
    ) : q;

// Priority: load over shift
wire [63:0] next_q = load ? data : shifted_value;

always @(posedge clk) begin
    q <= next_q;
end

endmodule