module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q; // Output of positive-edge triggered flip-flop
reg neg_edge_q; // Output of negative-edge triggered flip-flop
reg prev_clk;   // Previous clock value for edge detection

// Initialize previous clock value
initial prev_clk = 0;

// Positive-edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Negative-edge triggered flip-flop
always @(negedge clk)
    neg_edge_q <= d;

// Detect clock edge and update previous clock value
always @(*)
begin
    if (clk != prev_clk) begin
        if (clk == 1'b1) begin
            q <= pos_edge_q;
        end else begin
            q <= neg_edge_q;
        end
    end
    prev_clk <= clk;
end

endmodule