module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    wire c_lt4 = (c < 4);
    wire [1:0] c_lsb = c[1:0];

    // Group the inputs as in Example 2 for clarity
    wire [3:0] vector0 = b;
    wire [3:0] vector1 = e;
    wire [3:0] vector2 = a;
    wire [3:0] vector3 = d;

    always @(*) begin
        if (!c_lt4)
            q = 4'hF;
        else begin
            case (c_lsb)
                2'd0: q = vector0;  // b
                2'd1: q = vector1;  // e
                2'd2: q = vector2;  // a
                2'd3: q = vector3;  // d
                default: q = 4'hF;  // safety fallback
            endcase
        end
    end

endmodule