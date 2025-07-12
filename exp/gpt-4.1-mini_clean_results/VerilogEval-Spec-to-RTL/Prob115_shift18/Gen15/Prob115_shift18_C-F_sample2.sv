module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Declare shift result wires for left shifts only
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};

    // Declare shift result wires for right shifts only
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select shift amount based on amount[0] (0=1-bit shift, 1=8-bit shift)
    // but only compute left or right shift depending on amount[1].
    // To reduce power and area, select shifts conditionally:
    wire [63:0] shift_val = (amount[1] == 1'b0) 
                           ? ((amount[0] == 1'b0) ? shift_left_1  : shift_left_8 )
                           : ((amount[0] == 1'b0) ? shift_right_1 : shift_right_8);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_val;
    end

endmodule