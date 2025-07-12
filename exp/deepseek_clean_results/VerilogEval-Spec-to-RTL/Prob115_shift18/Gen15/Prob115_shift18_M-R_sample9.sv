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
wire shift_8 = amount[0];

// Shift operations
wire [63:0] left_shift_result = shift_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
wire [63:0] right_shift_result;
wire [7:0] sign_ext = {8{q[63]}};

assign right_shift_result = shift_8 ? {sign_ext, q[63:8]} : {q[63], q[63:1]};

// Next value calculation
wire [63:0] shifted_value = shift_right ? right_shift_result : left_shift_result;
wire [63:0] next_value = load ? data : (do_shift ? shifted_value : q);

// Register update
always @(posedge clk) begin
    q <= next_value;
end

endmodule