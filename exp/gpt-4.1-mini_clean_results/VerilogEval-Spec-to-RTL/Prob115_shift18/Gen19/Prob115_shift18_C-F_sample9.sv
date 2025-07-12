module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Compute shifts only when enabled, else keep q (for power saving)
    // Left shifts via concatenation
    wire [63:0] shift_left_1 = {q[62:0], 1'b0};
    wire [63:0] shift_left_8 = {q[55:0], 8'b0};

    // Arithmetic right shifts with sign extension
    wire [63:0] shift_right_1 = {sign, q[63:1]};
    wire [63:0] shift_right_8 = {{8{sign}}, q[63:8]};

    // Select shifted output according to amount
    wire [63:0] shifted = (amount == 2'b00) ? shift_left_1  :
                         (amount == 2'b01) ? shift_left_8  :
                         (amount == 2'b10) ? shift_right_1 :
                                             shift_right_8;

    // Compute next value with load and enable gating to reduce switching
    wire [63:0] next_val = load        ? data  :
                          ena         ? shifted:
                                        q     ;

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule