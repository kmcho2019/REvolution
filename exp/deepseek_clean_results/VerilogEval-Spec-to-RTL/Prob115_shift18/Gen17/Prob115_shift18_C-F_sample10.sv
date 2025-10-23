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
wire shift_by_8 = amount[0];

// Shift operations (computed only when needed)
wire [63:0] shift_result;
assign shift_result = shift_right ? 
    (shift_by_8 ? {{8{q[63]}}, q[63:8]} :  // Arithmetic right by 8
                  {q[63], q[63:1]}) :      // Arithmetic right by 1
    (shift_by_8 ? {q[55:0], 8'b0} :        // Left by 8
                  {q[62:0], 1'b0};         // Left by 1

// Next state logic with clear priority
wire [63:0] next_q = load ? data : (do_shift ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule