module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Shift left by 1 and 8 bits
    wire [63:0] shift_left_1 = {q[62:0], 1'b0};
    wire [63:0] shift_left_8 = {q[55:0], 8'b0};
    wire [63:0] shift_left_sel = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] shift_left = (amount[1] == 1'b0) ? shift_left_sel : 64'b0;

    // Arithmetic shift right by 1 and 8 bits
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};
    wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;
    wire [63:0] shift_right = (amount[1] == 1'b1) ? shift_right_sel : 64'b0;

    // Select shifted output based on direction
    wire [63:0] shifted = shift_left | shift_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule