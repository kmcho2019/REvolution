module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

reg pos_edge_q;

always @(posedge clk or negedge clk) begin
    if (clk) begin
        pos_edge_q <= d;
    end else begin
        q <= d;
    end
end

assign q = clk? pos_edge_q : q;

endmodule