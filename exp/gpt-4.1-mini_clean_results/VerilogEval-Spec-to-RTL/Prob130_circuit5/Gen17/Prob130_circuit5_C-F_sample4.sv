module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Decode c for gating inputs to reduce unnecessary toggling
    wire sel_b = (c == 4'd0);
    wire sel_e = (c == 4'd1);
    wire sel_a = (c == 4'd2);
    wire sel_d = (c == 4'd3);
    wire sel_f = (c >= 4'd4);

    // Gate inputs to minimize switching on unused inputs
    wire [3:0] gated_b = b & {4{sel_b}};
    wire [3:0] gated_e = e & {4{sel_e}};
    wire [3:0] gated_a = a & {4{sel_a}};
    wire [3:0] gated_d = d & {4{sel_d}};
    wire [3:0] const_f = 4'hF; // constant output when c>=4

    always @(*) begin
        case (1'b1)
            sel_b: q = gated_b;
            sel_e: q = gated_e;
            sel_a: q = gated_a;
            sel_d: q = gated_d;
            sel_f: q = const_f;
            default: q = 4'bxxxx; // undefined for x inputs; matches waveform initial x
        endcase
    end

endmodule