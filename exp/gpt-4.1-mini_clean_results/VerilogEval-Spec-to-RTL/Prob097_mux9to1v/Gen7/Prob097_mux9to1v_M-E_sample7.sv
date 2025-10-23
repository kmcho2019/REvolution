module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

    // First level muxes: group inputs into 3 groups of 3
    reg [15:0] group0, group1, group2;

    always @(*) begin
        // Group 0: sel[1:0] selects among a,b,c for sel=0,1,2
        case (sel[1:0])
            2'd0: group0 = a;
            2'd1: group0 = b;
            2'd2: group0 = c;
            default: group0 = 16'hFFFF; // shouldn't occur for valid sel
        endcase

        // Group 1: sel[1:0] selects among d,e,f for sel=3,4,5
        case (sel[1:0])
            2'd0: group1 = d;
            2'd1: group1 = e;
            2'd2: group1 = f;
            default: group1 = 16'hFFFF; // shouldn't occur for valid sel
        endcase

        // Group 2: sel[1:0] selects among g,h,i for sel=6,7,8
        case (sel[1:0])
            2'd0: group2 = g;
            2'd1: group2 = h;
            2'd2: group2 = i;
            default: group2 = 16'hFFFF; // shouldn't occur for valid sel
        endcase
    end

    always @(*) begin
        // Upper bits sel[3:2] decide which group to choose from
        // 00 -> group0 (0 to 2)
        // 01 -> group1 (3 to 5)
        // 10 -> group2 (6 to 8)
        // 11 -> invalid -> output all ones
        case (sel[3:2])
            2'b00: out = group0;
            2'b01: out = group1;
            2'b10: out = group2;
            default: out = 16'hFFFF;
        endcase
    end

endmodule