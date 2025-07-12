module DFF (
    input  clk,
    input  resetn,
    input  d,
    output reg q
);
    // Synchronous active-low reset DFF with non-blocking assignments
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    wire q0, q1, q2;

    // Explicitly instantiate each DFF for clear structure and easy debugging
    DFF dff0 (
        .clk(clk),
        .resetn(resetn),
        .d(in),
        .q(q0)
    );

    DFF dff1 (
        .clk(clk),
        .resetn(resetn),
        .d(q0),
        .q(q1)
    );

    DFF dff2 (
        .clk(clk),
        .resetn(resetn),
        .d(q1),
        .q(q2)
    );

    DFF dff3 (
        .clk(clk),
        .resetn(resetn),
        .d(q2),
        .q(out)
    );
endmodule