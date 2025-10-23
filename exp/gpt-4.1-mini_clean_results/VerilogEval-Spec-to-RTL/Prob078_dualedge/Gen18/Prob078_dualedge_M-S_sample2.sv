module EdgeFF #(parameter EDGE = 1) (
    input clk,
    input d,
    output reg q
);
    // EDGE = 1 for posedge, 0 for negedge
    generate
        if (EDGE) begin
            always @(posedge clk) q <= d;
        end else begin
            always @(negedge clk) q <= d;
        end
    endgenerate
endmodule

module TopModule (
    input clk,
    input d,
    output q
);

    wire q_pos, q_neg;

    EdgeFF #(1) pos_ff (.clk(clk), .d(d), .q(q_pos));
    EdgeFF #(0) neg_ff (.clk(clk), .d(d), .q(q_neg));

    assign q = clk ? q_pos : q_neg;

endmodule