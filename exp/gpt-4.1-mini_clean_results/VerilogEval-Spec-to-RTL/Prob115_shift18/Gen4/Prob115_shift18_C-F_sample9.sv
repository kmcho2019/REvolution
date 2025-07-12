module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    // Decode direction and shift amount
    wire direction = amount[1];      // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];    // 0: shift by 1, 1: shift by 8

    wire [5:0] shift_amount = shift_by_8 ? 6'd8 : 6'd1;

    wire [63:0] shift_left_val;
    wire [63:0] shift_right_val;

    // Shift left by shift_amount
    assign shift_left_val = (q << shift_amount);

    // Arithmetic right shift by shift_amount:
    // replicate sign bit (q[63]) shift_amount times on MSB side
    assign shift_right_val = { {64{q[63]}} } >> shift_amount | (q >> shift_amount);

    wire [63:0] shifted_val = (direction == 1'b0) ? shift_left_val : shift_right_val;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted_val;
        // else hold q
    end

endmodule