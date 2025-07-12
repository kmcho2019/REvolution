module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: Shift by 8 bits or no shift
    wire [63:0] stage1_left  = {q[55:0], 8'b0};
    wire [63:0] stage1_right = {{8{msb}}, q[63:8]};
    wire [63:0] stage1_shifted = (amount[0]) ? // amount[0] == 1 means shift by 8 bits
                                (amount[1] ? stage1_right : stage1_left)
                                : q;

    // Stage 2: Shift by 1 bit or no shift
    wire [63:0] stage2_left  = {stage1_shifted[62:0], 1'b0};
    wire [63:0] stage2_right = {stage1_shifted[63], stage1_shifted[63:1]};

    wire [63:0] stage2_shifted = (amount[1]) ? // amount[1] == 1 means right shift by 1 bit
                               stage2_right
                               : stage2_left;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2_shifted;
    end

endmodule