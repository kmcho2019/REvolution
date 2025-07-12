module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Left shifts by concatenation
    wire [63:0] shift_left_1 = {q[62:0], 1'b0};
    wire [63:0] shift_left_8 = {q[55:0], 8'b0};

    // Arithmetic right shifts by concatenation of sign bit
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select left shift amount mux: 0->1-bit, 1->8-bit
    wire [63:0] left_shift_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    // Select right shift amount mux
    wire [63:0] right_shift_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select direction mux: 0->left shift, 1->right shift
    wire [63:0] shifted = (amount[1] == 1'b0) ? left_shift_sel : right_shift_sel;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule