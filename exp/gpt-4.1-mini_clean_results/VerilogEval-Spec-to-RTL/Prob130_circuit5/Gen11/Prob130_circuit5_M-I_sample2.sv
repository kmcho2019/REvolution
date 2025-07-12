module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Saturate c at 4 for selection to avoid out-of-bounds
    wire [2:0] sel = (c > 4) ? 3'd4 : c[2:0];

    always @(*) begin
        case (sel)
            3'd0: q = b;
            3'd1: q = e;
            3'd2: q = a;
            3'd3: q = d;
            3'd4: q = 4'hF;
            default: q = 4'hF; // default safety
        endcase
    end

endmodule