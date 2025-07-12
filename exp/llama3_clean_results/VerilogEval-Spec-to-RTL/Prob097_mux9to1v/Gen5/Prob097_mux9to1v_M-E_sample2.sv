module TopModule(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
    input [3:0] sel,
    output reg [15:0] out
);

reg [15:0] group0_out;
reg [15:0] group1_out;

always @(*)
begin
    // Group 0: sel = 0 to 3
    case (sel[2:0])
        3'd0: group0_out = a;
        3'd1: group0_out = b;
        3'd2: group0_out = c;
        3'd3: group0_out = d;
        default: group0_out = 16'hffff;
    endcase

    // Group 1: sel = 4 to 8
    case (sel[2:0])
        3'd0: group1_out = e;
        3'd1: group1_out = f;
        3'd2: group1_out = g;
        3'd3: group1_out = h;
        3'd4: group1_out = i;
        default: group1_out = 16'hffff;
    endcase

    // Top-level 2-to-1 multiplexer
    case (sel[3])
        1'd0: out = group0_out;
        1'd1: out = group1_out;
        default: out = 16'hffff;
    endcase
end

endmodule