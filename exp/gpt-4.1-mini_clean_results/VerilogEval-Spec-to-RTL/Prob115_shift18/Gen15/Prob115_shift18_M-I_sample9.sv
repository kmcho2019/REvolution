module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Partial shifts: shift by 1 and shift by 8 (left and right)
    wire [63:0] shift1_left  = {q[62:0], 1'b0};
    wire [63:0] shift8_left  = {q[55:0], 8'b0};
    wire [63:0] shift1_right = {sign, q[63:1]};
    wire [63:0] shift8_right = {{8{sign}}, q[63:8]};

    // Select shift magnitude first: shift by 1 or shift by 8
    wire [63:0] shift_left  = (amount[0] == 1'b0) ? shift1_left : shift8_left;
    wire [63:0] shift_right = (amount[0] == 1'b0) ? shift1_right : shift8_right;

    // Select direction based on amount[1]
    wire [63:0] shift_result = (amount[1] == 1'b0) ? shift_left : shift_right;

    // Next value with synchronous load and enable gating
    wire [63:0] next_val = load ? data :
                          (ena ? shift_result : q);

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule