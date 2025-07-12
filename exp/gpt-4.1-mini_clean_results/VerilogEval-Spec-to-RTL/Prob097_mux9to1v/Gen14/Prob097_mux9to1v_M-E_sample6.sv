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

    // First level: 3 groups of 3-to-1 muxes, select using sel[1:0]
    reg [15:0] group0_out;
    reg [15:0] group1_out;
    reg [15:0] group2_out;

    always @(*) begin
        // Group 0 mux
        case (sel[1:0])
            2'd0: group0_out = a;
            2'd1: group0_out = b;
            2'd2: group0_out = c;
            default: group0_out = 16'hFFFF; // Defensive, though sel[1:0] only 0-3
        endcase

        // Group 1 mux
        case (sel[1:0])
            2'd0: group1_out = d;
            2'd1: group1_out = e;
            2'd2: group1_out = f;
            default: group1_out = 16'hFFFF;
        endcase

        // Group 2 mux
        case (sel[1:0])
            2'd0: group2_out = g;
            2'd1: group2_out = h;
            2'd2: group2_out = i;
            default: group2_out = 16'hFFFF;
        endcase
    end

    always @(*) begin
        if (sel > 4'd8)
            out = 16'hFFFF;
        else begin
            // Final mux: select among the three group outputs using sel[3:2]
            case (sel[3:2])
                2'd0: out = group0_out;
                2'd1: out = group1_out;
                2'd2: out = group2_out;
                default: out = 16'hFFFF; // Defensive, sel values 0-8 valid only here
            endcase
        end
    end

endmodule