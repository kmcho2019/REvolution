module TopModule(
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

    // First-level 3-to-1 mux function
    function [15:0] mux3to1(
        input [15:0] in0,
        input [15:0] in1,
        input [15:0] in2,
        input [1:0]  sel2
    );
        begin
            case(sel2)
                2'd0: mux3to1 = in0;
                2'd1: mux3to1 = in1;
                2'd2: mux3to1 = in2;
                default: mux3to1 = 16'hFFFF;
            endcase
        end
    endfunction

    always @(*) begin
        if (sel < 4'd9) begin
            // Break sel into two parts: upper bit (sel[3:2]) and lower two bits (sel[1:0])
            // First level muxes select among three inputs each
            // Level 1 mux outputs
            reg [15:0] lvl1_0, lvl1_1, lvl1_2;

            lvl1_0 = mux3to1(a, b, c, sel[1:0]);
            lvl1_1 = mux3to1(d, e, f, sel[1:0]);
            lvl1_2 = mux3to1(g, h, i, sel[1:0]);

            // Level 2 mux chooses among lvl1 outputs based on sel[3:2]
            out = mux3to1(lvl1_0, lvl1_1, lvl1_2, sel[3:2]);
        end else begin
            out = 16'hFFFF;
        end
    end

endmodule