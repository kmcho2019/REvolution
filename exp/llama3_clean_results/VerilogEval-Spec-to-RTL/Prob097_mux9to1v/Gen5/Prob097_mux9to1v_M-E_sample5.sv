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

// Intermediate signals for group selections
reg [15:0] group1_out;
reg [15:0] group2_out;
reg [15:0] group3_out;

// First stage: 3-to-1 multiplexers for each group
always @(*)
begin
    case (sel[1:0])
        2'd0: group1_out = a;
        2'd1: group1_out = b;
        2'd2: group1_out = c;
        default: group1_out = 16'h0; // Default for group1, not used
    endcase

    case ({sel[3:2], 1'b0})
        2'd0: group2_out = d;
        2'd1: group2_out = e;
        2'd2: group2_out = f;
        default: group2_out = 16'h0; // Default for group2, not used
    endcase

    case ({sel[3:2], 1'b0})
        2'd0: group3_out = g;
        2'd1: group3_out = h;
        2'd2: group3_out = i;
        default: group3_out = 16'hffff; // Default for group3, used for sel > 8
    endcase
end

// Second stage: Final selection between group outputs
always @(*)
begin
    case (sel[3:2])
        2'd0: out = group1_out;
        2'd1: out = group2_out;
        2'd2: out = group3_out;
        default: out = 16'hffff; // Default for sel > 8
    endcase
end

endmodule