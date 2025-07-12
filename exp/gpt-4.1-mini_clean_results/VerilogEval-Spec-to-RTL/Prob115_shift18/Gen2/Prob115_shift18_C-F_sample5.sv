module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode control signals from amount:
    // direction: 0 = left shift, 1 = arithmetic right shift
    wire direction = amount[1];
    // shift by 8 enable: set if amount[0] == 1
    wire shift8 = amount[0];
    // shift by 1 enable: true when amount is 00 (left by 1) or 10 (right by 1)
    wire shift1 = (amount == 2'b00) || (amount == 2'b10);

    // Stage 1 and stage 2 results as wires (combinational)
    wire [63:0] stage1;
    wire [63:0] stage2;

    // Left shift stage1: if shift8 set, shift left by 8, else pass through
    assign stage1 = (direction == 1'b0) ? 
                    (shift8 ? (q << 8) : q) :
                    // Right arithmetic shift stage1: if shift8 set, arithmetic shift right by 8, else pass through
                    (shift8 ? ({ {8{q[63]}}, q[63:8] }) : q);

    // Stage2 applies 1-bit shift (left or right arithmetic) if shift1 set, else pass through
    assign stage2 = (direction == 1'b0) ?
                    (shift1 ? (stage1 << 1) : stage1) :
                    (shift1 ? ({ stage1[63], stage1[63:1] }) : stage1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2;
        // else hold q
    end

endmodule