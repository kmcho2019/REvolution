module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    // Intermediate signals for staged shifting
    wire dir_right = amount[1];  // 0 = left, 1 = arithmetic right
    wire shift_1st = amount[0];  // 0 = shift by 1 bit, 1 = shift by 8 bits

    // First stage shift amount: shift by 8 bits if shift_1st=1, else no shift
    // Second stage shift amount: shift by 1 bit if shift_1st=0, else no shift
    // To implement a clean two-stage barrel:
    // - Stage 1 shifts by 8 bits if shift_1st=1
    // - Stage 2 shifts by 1 bit if shift_1st=0

    // Stage 1 shift by 8 bits if shift_1st=1, else pass through
    wire [63:0] stage1_shifted;
    generate
        if (dir_right) begin
            // Arithmetic right shift by 8 bits or pass through
            assign stage1_shifted = shift_1st ?
                {{8{q[63]}}, q[63:8]} : q;
        end else begin
            // Left shift by 8 bits or pass through
            assign stage1_shifted = shift_1st ?
                {q[55:0], 8'b0} : q;
        end
    endgenerate

    // Stage 2 shift by 1 bit if shift_1st=0, else pass stage1 result as is
    wire [63:0] stage2_shifted;
    generate
        if (dir_right) begin
            // Arithmetic right shift by 1 bit or pass through
            assign stage2_shifted = shift_1st ? stage1_shifted :
                {stage1_shifted[63], stage1_shifted[63:1]};
        end else begin
            // Left shift by 1 bit or pass through
            assign stage2_shifted = shift_1st ? stage1_shifted :
                {stage1_shifted[62:0], 1'b0};
        end
    endgenerate

    wire [63:0] shifted_val = stage2_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted_val;
        // else hold q
    end

endmodule