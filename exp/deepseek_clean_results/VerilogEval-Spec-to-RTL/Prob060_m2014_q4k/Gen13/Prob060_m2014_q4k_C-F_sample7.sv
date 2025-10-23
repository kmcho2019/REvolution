module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Internal nodes between flip-flops
    wire [2:0] q;
    
    // Explicitly named DFF instances for clarity
    DFF dff0 (.clk(clk), .resetn(resetn), .d(in),         .q(q[0]));
    DFF dff1 (.clk(clk), .resetn(resetn), .d(q[0]),       .q(q[1]));
    DFF dff2 (.clk(clk), .resetn(resetn), .d(q[1]),       .q(q[2]));
    DFF dff3 (.clk(clk), .resetn(resetn), .d(q[2]),       .q(out));

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