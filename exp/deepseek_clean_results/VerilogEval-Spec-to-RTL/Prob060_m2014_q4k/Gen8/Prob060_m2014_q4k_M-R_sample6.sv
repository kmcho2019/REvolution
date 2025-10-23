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

module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire [2:0] internal_nodes;
    
    DFF dff0 (.clk(clk), .resetn(resetn), .d(in), .q(internal_nodes[0]));
    DFF dff1 (.clk(clk), .resetn(resetn), .d(internal_nodes[0]), .q(internal_nodes[1]));
    DFF dff2 (.clk(clk), .resetn(resetn), .d(internal_nodes[1]), .q(internal_nodes[2]));
    DFF dff3 (.clk(clk), .resetn(resetn), .d(internal_nodes[2]), .q(out));

endmodule