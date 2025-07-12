module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] next_q;
wire [63:0] shifted_value;

// Shift direction and amount decoding
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Shift computation (done only when ena is high)
assign shifted_value = (ena) ? 
                      (shift_right ? 
                       (shift_8 ? {{8{q[63]}}, q[63:8]} : // Right 8
                                 {q[63], q[63:1]}) :      // Right 1
                       (shift_8 ? {q[55:0], 8'b0} :       // Left 8
                                 {q[62:0], 1'b0})         // Left 1
                      ) : q;

// Load has priority over shift
assign next_q = load ? data : shifted_value;

always @(posedge clk) begin
    q <= next_q;
end

endmodule