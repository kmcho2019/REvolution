module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode control signals from amount
    // direction: 0 = left shift, 1 = right shift (arithmetic)
    wire direction = amount[1];
    // shift by 8 bits enable
    wire shift8 = amount[0];
    // shift by 1 bit enable (only if not shifting by 8 bits in left shifts)
    // but since amount encodes mutually exclusive shifts, for left shifts, 00 means shift by 1, 01 by 8
    // for right shifts, 10 means shift right by 1, 11 by 8
    wire shift1 = (amount == 2'b00) || (amount == 2'b10);

    // Intermediate signals for staged shifts
    reg [63:0] stage1;  // after 8-bit shift stage
    reg [63:0] stage2;  // after 1-bit shift stage

    always @(*) begin
        if (!direction) begin
            // Left shifts
            if (shift8)
                stage1 = q << 8;
            else
                stage1 = q;
            if (shift1)
                stage2 = stage1 << 1;
            else
                stage2 = stage1;
        end else begin
            // Arithmetic right shifts
            // replicate MSB for arithmetic shift
            if (shift8)
                stage1 = { {8{q[63]}}, q[63:8] };
            else
                stage1 = q;
            if (shift1)
                stage2 = { stage1[63], stage1[63:1] };
            else
                stage2 = stage1;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= stage2;
        end
        // else hold q
    end

endmodule