module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    // Decode direction and shift magnitude from amount
    wire direction = amount[1]; // 0: left, 1: arithmetic right
    wire shift_by_8 = amount[0];
    wire shift_by_1 = (amount == 2'b00) || (amount == 2'b10);

    // Stage 1: shift by 8 bits if requested, else pass input through
    wire [63:0] stage1 = (direction == 1'b0) ?
                         (shift_by_8 ? (q << 8) : q) :
                         (shift_by_8 ? ({ {8{q[63]}}, q[63:8] }) : q);

    // Stage 2: shift by 1 bit if requested, else pass stage1 through
    wire [63:0] stage2 = (direction == 1'b0) ?
                         (shift_by_1 ? (stage1 << 1) : stage1) :
                         (shift_by_1 ? ({ stage1[63], stage1[63:1] }) : stage1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2;
        // else hold q
    end

endmodule