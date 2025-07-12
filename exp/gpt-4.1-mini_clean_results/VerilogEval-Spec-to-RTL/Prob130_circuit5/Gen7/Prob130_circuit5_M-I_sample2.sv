module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Clamp c to max 4 to avoid out-of-range indexes
    wire [3:0] c_clamped = (c > 4'd4) ? 4'd4 : c;

    always @(*) begin
        case (c_clamped)
            4'd0: q = b;
            4'd1: q = e;
            4'd2: q = a;
            4'd3: q = d;
            4'd4: q = 4'hF;
            default: q = 4'hF; // Defensive default
        endcase
    end

endmodule