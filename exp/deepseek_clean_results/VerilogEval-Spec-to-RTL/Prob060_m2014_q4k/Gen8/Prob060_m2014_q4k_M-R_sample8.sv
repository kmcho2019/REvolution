module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Individual flip-flop outputs
    wire q0, q1, q2, q3;

    // First stage flip-flop
    dff dff0 (
        .clk(clk),
        .resetn(resetn),
        .d(in),
        .q(q0)
    );

    // Second stage flip-flop
    dff dff1 (
        .clk(clk),
        .resetn(resetn),
        .d(q0),
        .q(q1)
    );

    // Third stage flip-flop
    dff dff2 (
        .clk(clk),
        .resetn(resetn),
        .d(q1),
        .q(q2)
    );

    // Fourth stage flip-flop
    dff dff3 (
        .clk(clk),
        .resetn(resetn),
        .d(q2),
        .q(q3)
    );

    // Output assignment
    assign out = q3;

endmodule

// D flip-flop with synchronous active-low reset
module dff (
    input clk,
    input resetn,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= !resetn ? 1'b0 : d;
    end

endmodule