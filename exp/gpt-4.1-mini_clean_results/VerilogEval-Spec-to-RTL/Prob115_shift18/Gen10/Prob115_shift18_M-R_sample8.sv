module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Shift left by 8 bits (logical)
    wire [63:0] shift8_left = {q[55:0], 8'b0};
    // Shift right by 8 bits (arithmetic)
    wire [63:0] shift8_right = {{8{sign}}, q[63:8]};
    // Shift left by 1 bit (logical)
    wire [63:0] shift1_left = {q[62:0], 1'b0};
    // Shift right by 1 bit (arithmetic)
    wire [63:0] shift1_right = {sign, q[63:1]};

    wire [63:0] shift_result = (amount[1] == 1'b0) ?
                                (amount[0] == 1'b0 ? shift1_left : shift8_left) :
                                (amount[0] == 1'b0 ? shift1_right : shift8_right);

    wire [63:0] next_val = load ? data :
                          (ena ? shift_result : q);

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule