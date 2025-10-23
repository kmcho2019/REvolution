module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // One-hot enables for inputs, mutually exclusive
    wire sel_b = (c == 4'd0);
    wire sel_e = (c == 4'd1);
    wire sel_a = (c == 4'd2);
    wire sel_d = (c == 4'd3);
    wire sel_f = (c > 4'd3);

    // Gate inputs by enables to reduce switching on unselected inputs
    wire [3:0] gated_b = b & {4{sel_b}};
    wire [3:0] gated_e = e & {4{sel_e}};
    wire [3:0] gated_a = a & {4{sel_a}};
    wire [3:0] gated_d = d & {4{sel_d}};

    always @(*) begin
        if (sel_f)
            q = 4'hF;
        else 
            // Because enables are mutually exclusive, OR of gated inputs selects the correct input with gating
            q = gated_b | gated_e | gated_a | gated_d;
    end

endmodule