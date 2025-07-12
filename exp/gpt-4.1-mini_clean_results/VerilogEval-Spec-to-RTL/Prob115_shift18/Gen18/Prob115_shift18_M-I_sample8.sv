module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];        // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    wire msb = q[63];

    // Shift left logic
    // Step 1: shift by 8 or no shift
    wire [63:0] left_stage1 = shift_by_8 ? {q[55:0], 8'b0} : q;
    // Step 2: shift by 1 or no shift
    wire [63:0] left_shifted = amount[1] ? {left_stage1[62:0], 1'b0} : left_stage1;

    // Arithmetic right shift logic
    // Step 1: shift by 8 or no shift with sign extension
    wire [63:0] right_stage1 = shift_by_8 ? { {8{msb}}, q[63:8] } : q;
    // Step 2: shift by 1 or no shift with sign extension
    wire [63:0] right_shifted = amount[1] ? { msb, right_stage1[63:1] } : right_stage1;

    wire [63:0] shifted = dir ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule