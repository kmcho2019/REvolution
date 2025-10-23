module DFF (
    input clk,
    input resetn,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    wire q0, q1, q2, q3;

    DFF ff0(.clk(clk), .resetn(resetn), .d(in), .q(q0));
    DFF ff1(.clk(clk), .resetn(resetn), .d(q0), .q(q1));
    DFF ff2(.clk(clk), .resetn(resetn), .d(q1), .q(q2));
    DFF ff3(.clk(clk), .resetn(resetn), .d(q2), .q(q3));

    assign out = q3;

endmodule