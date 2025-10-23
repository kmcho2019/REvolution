module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Shift computations
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select shifts by amount[0] (1 or 8 bits)
    wire [63:0] left_shift_val  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] right_shift_val = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select final shift direction by amount[1]
    wire [63:0] shift_val = (amount[1] == 1'b0) ? left_shift_val : right_shift_val;

    // Compute next state combinationally
    wire [63:0] next_q = load ? data : (ena ? shift_val : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule