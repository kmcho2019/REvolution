// Refactored TopModule with direct D flip-flop instantiation
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Direct instantiation of 8 D flip-flops with asynchronous reset
    dff_ar dff0(.q(q[0]), .d(d[0]), .clk(clk), .areset(areset));
    dff_ar dff1(.q(q[1]), .d(d[1]), .clk(clk), .areset(areset));
    dff_ar dff2(.q(q[2]), .d(d[2]), .clk(clk), .areset(areset));
    dff_ar dff3(.q(q[3]), .d(d[3]), .clk(clk), .areset(areset));
    dff_ar dff4(.q(q[4]), .d(d[4]), .clk(clk), .areset(areset));
    dff_ar dff5(.q(q[5]), .d(d[5]), .clk(clk), .areset(areset));
    dff_ar dff6(.q(q[6]), .d(d[6]), .clk(clk), .areset(areset));
    dff_ar dff7(.q(q[7]), .d(d[7]), .clk(clk), .areset(areset));

endmodule

// Primitive D flip-flop with asynchronous reset
module dff_ar(
    output  q,
    input   d,
    input   clk,
    input   areset
);

    reg q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule