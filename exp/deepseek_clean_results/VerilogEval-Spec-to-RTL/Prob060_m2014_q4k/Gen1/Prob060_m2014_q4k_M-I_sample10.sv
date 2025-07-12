module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Explicitly instantiated DFFs for potential better optimization
    wire [3:0] q;
    
    DFF dff0 (.clk(clk), .resetn(resetn), .d(in), .q(q[0]));
    DFF dff1 (.clk(clk), .resetn(resetn), .d(q[0]), .q(q[1]));
    DFF dff2 (.clk(clk), .resetn(resetn), .d(q[1]), .q(q[2]));
    DFF dff3 (.clk(clk), .resetn(resetn), .d(q[2]), .q(q[3]));
    
    assign out = q[3];

endmodule

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