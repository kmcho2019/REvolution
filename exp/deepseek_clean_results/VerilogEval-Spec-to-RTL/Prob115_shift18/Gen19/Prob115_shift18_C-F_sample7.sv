module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals (gated with ena for power efficiency)
wire do_shift = ena & ~load;
wire shift_right = amount[1] & do_shift;
wire shift_by_8 = amount[0] & do_shift;

// Shift operations (only computed when needed)
wire [63:0] left_shift = shift_by_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
wire [63:0] right_shift = shift_by_8 ? 
                         {{8{q[63]}}, q[63:8]} :  // Arithmetic right shift by 8
                         {q[63], q[63:1]};       // Arithmetic right shift by 1

// Next state logic (optimized multiplexer structure)
wire [63:0] next_q = load ? data : 
                    (shift_right ? right_shift : 
                    (do_shift ? left_shift : q));

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule