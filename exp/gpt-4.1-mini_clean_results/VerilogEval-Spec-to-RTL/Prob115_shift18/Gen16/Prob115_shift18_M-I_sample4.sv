module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];         // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];  // 0: shift by 1, 1: shift by 8

    // Compute shift amounts
    // For left shift, shift left by 1 or 8 bits (fill with zeros)
    // For arithmetic right shift, shift right by 1 or 8 bits (fill with sign bit)
    wire [63:0] left_shift = shift_by_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
    wire [63:0] right_shift = shift_by_8 ? {{8{q[63]}}, q[63:8]} : {{1{q[63]}}, q[63:1]};

    wire [63:0] shifted = dir ? right_shift : left_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else retain q
    end

endmodule