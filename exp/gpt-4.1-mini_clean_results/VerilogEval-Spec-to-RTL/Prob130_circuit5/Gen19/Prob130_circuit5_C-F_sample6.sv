module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Cap c at 4 to prevent out-of-range
    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    always @(*) begin
        case(idx)
            3'd0: q = b;
            3'd1: q = e;
            3'd2: q = a;
            3'd3: q = d;
            default: q = 4'hF;
        endcase
    end

endmodule