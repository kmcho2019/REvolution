module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire q0, q1, q2;
    
    // First flip-flop
    dff dff0 (
        .clk(clk),
        .resetn(resetn),
        .d(in),
        .q(q0)
    );
    
    // Second flip-flop
    dff dff1 (
        .clk(clk),
        .resetn(resetn),
        .d(q0),
        .q(q1)
    );
    
    // Third flip-flop
    dff dff2 (
        .clk(clk),
        .resetn(resetn),
        .d(q1),
        .q(q2)
    );
    
    // Fourth flip-flop
    dff dff3 (
        .clk(clk),
        .resetn(resetn),
        .d(q2),
        .q(out)
    );

endmodule

// D flip-flop module with synchronous active-low reset
module dff (
    input clk,
    input resetn,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (!resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule