module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_right = amount[1];
wire shift_8 = amount[0];
wire do_shift = ena & ~load;

// Shift amount calculation
wire [5:0] shift_amt = shift_8 ? 6'd8 : 6'd1;

// Shift operations
wire [63:0] left_shift = q << shift_amt;
wire [63:0] right_shift = shift_8 ? 
                         {{8{q[63]}}, q[63:8]} : 
                         {{1{q[63]}}, q[63:1]};

// Next state logic
wire [63:0] next_q = load ? data : 
                    (do_shift ? (shift_right ? right_shift : left_shift) : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule