module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Decode direction and amount
    wire dir_left = ~amount[1];    // 0 means left shift, 1 means right shift
    wire amt_1   = ~amount[0];     // 0 means shift by 1, 1 means shift by 8

    // Shift left by 1 or 8
    wire [63:0] shift_left_1 = {q[62:0], 1'b0};
    wire [63:0] shift_left_8 = {q[55:0], 8'b0};

    // Shift right by 1 or 8 (arithmetic right shift)
    wire [63:0] shift_right_1 = {sign, q[63:1]};
    wire [63:0] shift_right_8 = {{8{sign}}, q[63:8]};

    // Select shift amount
    wire [63:0] shift_left = amt_1 ? shift_left_8 : shift_left_1;
    wire [63:0] shift_right = amt_1 ? shift_right_8 : shift_right_1;

    // Select direction
    wire [63:0] shift_result = dir_left ? shift_left : shift_right;

    wire [63:0] next_val = load ? data :
                          (ena ? shift_result : q);

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule