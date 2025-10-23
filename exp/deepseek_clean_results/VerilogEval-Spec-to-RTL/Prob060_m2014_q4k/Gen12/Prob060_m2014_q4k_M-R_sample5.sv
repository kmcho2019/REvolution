module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Individual flip-flop outputs
    wire q0, q1, q2, q3;
    
    // First DFF
    DFF dff0 (
        .clk(clk),
        .resetn(resetn),
        .d(in),
        .q(q0)
    );
    
    // Second DFF
    DFF dff1 (
        .clk(clk),
        .resetn(resetn),
        .d(q0),
        .q(q1)
    );
    
    // Third DFF
    DFF dff2 (
        .clk(clk),
        .resetn(resetn),
        .d(q1),
        .q(q2)
    );
    
    // Fourth DFF
    DFF dff3 (
        .clk(clk),
        .resetn(resetn),
        .d(q2),
        .q(q3)
    );
    
    assign out = q3;

endmodule

// D Flip-Flop with synchronous active-low reset
module DFF (
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