module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire direction = amount[1];    // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];  // 0: shift by 1, 1: shift by 8
    wire [5:0] shift_val = shift_by_8 ? 6'd8 : 6'd1;

    wire sign_bit = q[63];
    wire [63:0] shifted = direction
        ? ({ {64{sign_bit}} } << (64 - shift_val)) | (q >> shift_val)  // Arithmetic right shift
        : q << shift_val;                                               // Left shift

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule