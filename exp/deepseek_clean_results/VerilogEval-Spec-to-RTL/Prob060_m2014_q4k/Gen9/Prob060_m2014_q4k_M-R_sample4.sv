module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire [3:0] d;
    wire [3:0] q;
    
    // First stage
    assign d[0] = in;
    dff dff0 (
        .clk(clk),
        .resetn(resetn),
        .d(d[0]),
        .q(q[0])
    );
    
    // Second stage
    assign d[1] = q[0];
    dff dff1 (
        .clk(clk),
        .resetn(resetn),
        .d(d[1]),
        .q(q[1])
    );
    
    // Third stage
    assign d[2] = q[1];
    dff dff2 (
        .clk(clk),
        .resetn(resetn),
        .d(d[2]),
        .q(q[2])
    );
    
    // Fourth stage (output)
    assign d[3] = q[2];
    dff dff3 (
        .clk(clk),
        .resetn(resetn),
        .d(d[3]),
        .q(q[3])
    );
    
    assign out = q[3];

endmodule

// D flip-flop with synchronous active-low reset
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