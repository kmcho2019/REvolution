module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signal decoding
wire shift_left = ~amount[1];
wire shift_by_8 = amount[0];

// Shift operations
wire [63:0] left_shift = shift_by_8 ? (q << 8) : (q << 1);
wire [63:0] right_shift = shift_by_8 ? 
                         ({ {8{q[63]}}, q[63:8] }) :  // Arithmetic right shift by 8
                         ({ q[63], q[63:1] });       // Arithmetic right shift by 1

// Next state logic
wire [63:0] next_q = load ? data : 
                   (ena ? (shift_left ? left_shift : right_shift) : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule