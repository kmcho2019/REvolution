module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Data array: index 0 = b, 1 = e, 2 = a, 3 = d, 4 = 4'hF (default)
    wire [3:0] data [0:4];
    assign data[0] = b;
    assign data[1] = e;
    assign data[2] = a;
    assign data[3] = d;
    assign data[4] = 4'hF;

    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    always @(*) begin
        case (idx)
            3'd0: q = data[0];
            3'd1: q = data[1];
            3'd2: q = data[2];
            3'd3: q = data[3];
            default: q = data[4];
        endcase
    end

endmodule