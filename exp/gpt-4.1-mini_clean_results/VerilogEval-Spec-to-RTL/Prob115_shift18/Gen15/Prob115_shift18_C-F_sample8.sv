module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Compute left shifts only if direction is left (amount[1]==0)
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_left_sel = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] shift_left    = (amount[1] == 1'b0) ? shift_left_sel : 64'd0;

    // Compute right shifts only if direction is right (amount[1]==1)
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};
    wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;
    wire [63:0] shift_right   = (amount[1] == 1'b1) ? shift_right_sel : 64'd0;

    // Final shift selection: only one of shift_left or shift_right is active
    wire [63:0] shifted = shift_left | shift_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule