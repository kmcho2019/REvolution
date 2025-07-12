module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control signals
wire do_shift = ena & ~load;
wire [1:0] shift_sel = amount;

// Shift value computation
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = q >>> 1;
wire [63:0] shift_right_8 = q >>> 8;

// Next state logic
wire [63:0] next_q = load ? data :
                    do_shift ? 
                    (shift_sel == 2'b00 ? shift_left_1 :
                     shift_sel == 2'b01 ? shift_left_8 :
                     shift_sel == 2'b10 ? shift_right_1 :
                     shift_right_8) : q;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule