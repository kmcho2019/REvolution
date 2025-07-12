module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: shift by 1 bit or no shift (depends on amount[0])
    // If amount[0] = 0 -> shift by 1
    // If amount[0] = 1 -> no shift (pass through)
    wire [63:0] shift1_left;
    wire [63:0] shift1_right;
    wire [63:0] shift1_sel;

    // shift left by 1 bit: lower bits shifted up, LSB filled with 0
    assign shift1_left  = {q[62:0], 1'b0};

    // arithmetic shift right by 1 bit: MSB replicated, rest shifted right by 1
    assign shift1_right = {msb, q[63:1]};

    // For amount[1] = 0 (shift left), stage1 selects left shift or no shift by amount[0]
    // For amount[1] = 1 (shift right), stage1 selects right shift or no shift by amount[0]
    // We generate two candidates and then select based on amount[1]

    // For no shift (when amount[0] = 1), simply pass q through stage 1
    wire [63:0] stage1_left  = (amount[0] == 1'b0) ? shift1_left  : q;
    wire [63:0] stage1_right = (amount[0] == 1'b0) ? shift1_right : q;

    // Select between left and right depending on amount[1]
    assign shift1_sel = (amount[1] == 1'b0) ? stage1_left : stage1_right;

    // Stage 2: shift by 8 bits or no shift (depends on amount[1])
    // But since amount[1] is already used above for direction,
    // here we interpret amount[1] as direction:
    // amount[1]=0 -> shift left 8 or no shift
    // amount[1]=1 -> shift right 8 or no shift
    // amount[0] chooses whether shift happens at all at stage 1,
    // so here amount[1] chooses direction, and we use amount[0] for the first stage shift amount.
    // To differentiate shift of 8 or no shift, we use amount[1] and amount[0]:
    // Let's do stage 2 shift by 8 if amount[0]=1, otherwise no shift.
    // But since amount[0] already used in stage 1, stage 2 shift amount depends on amount[1].

    // Instead, reinterpret:
    // To implement shifts by 1 or 8 bits combined, stage 1 shifts by 1-bit when amount[0] = 0, else no shift.
    // Stage 2 shifts by 8 bits when amount[0] = 1, else no shift.
    // Direction controlled by amount[1].

    // So stage 1 now is shift by 1 or no shift based on amount[0]==0
    // Stage 2 now shifts the output of stage 1 by 8 bits left or right if amount[0]==1; else no shift.

    // Adjust accordingly:

    wire [63:0] shift2_left  = {shift1_sel[55:0], 8'b0};     // shift left 8 bits
    wire [63:0] shift2_right = {{8{shift1_sel[63]}}, shift1_sel[63:8]}; // arithmetic shift right 8 bits

    // stage 2 output: if amount[0]==1, shift by 8 bits, else no shift (pass through stage1 output)
    wire [63:0] stage2_left  = (amount[0] == 1'b1) ? shift2_left  : shift1_sel;
    wire [63:0] stage2_right = (amount[0] == 1'b1) ? shift2_right : shift1_sel;

    // select final shift based on direction bit amount[1]
    wire [63:0] shift_final = (amount[1] == 1'b0) ? stage2_left : stage2_right;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_final;
        end
    end

endmodule