module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // One-hot enables for each valid c value 0..3
    wire sel_b = (c == 4'd0);
    wire sel_e = (c == 4'd1);
    wire sel_a = (c == 4'd2);
    wire sel_d = (c == 4'd3);

    // Gate inputs to minimize switching on unselected inputs
    wire [3:0] gated_b = b & {4{sel_b}};
    wire [3:0] gated_e = e & {4{sel_e}};
    wire [3:0] gated_a = a & {4{sel_a}};
    wire [3:0] gated_d = d & {4{sel_d}};

    always @(*) begin
        case (c)
            4'd0: q = gated_b;
            4'd1: q = gated_e;
            4'd2: q = gated_a;
            4'd3: q = gated_d;
            default: q = 4'hF;
        endcase
    end

endmodule