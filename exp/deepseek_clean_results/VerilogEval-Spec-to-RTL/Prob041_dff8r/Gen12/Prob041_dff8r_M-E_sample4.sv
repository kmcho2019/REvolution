module BitCell (
    input clk,
    input reset,
    input d,
    input scan_in,
    input scan_en,
    output reg q,
    output scan_out
);
    // Individual DFF with scan capability
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (scan_en)
            q <= scan_in;
        else
            q <= d;
    end
    
    assign scan_out = q;
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Local clock buffer for better clock distribution
    wire local_clk;
    BUFGCE clk_buf (
        .I(clk),
        .CE(1'b1),
        .O(local_clk)
    );
    
    // Shared reset buffer
    wire local_reset;
    BUFG reset_buf (
        .I(reset),
        .O(local_reset)
    );
    
    // Generate the 8-bit register with scan chain
    genvar i;
    wire [7:0] scan_chain;
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            if (i == 0) begin
                BitCell cell (
                    .clk(local_clk),
                    .reset(local_reset),
                    .d(d[i]),
                    .scan_in(1'b0),      // Normally 0, can be overridden for test
                    .scan_en(1'b0),      // Normal operation mode
                    .q(q[i]),
                    .scan_out(scan_chain[i])
                );
            end else begin
                BitCell cell (
                    .clk(local_clk),
                    .reset(local_reset),
                    .d(d[i]),
                    .scan_in(scan_chain[i-1]),
                    .scan_en(1'b0),      // Normal operation mode
                    .q(q[i]),
                    .scan_out(scan_chain[i])
                );
            end
        end
    endgenerate
    
    // Optional: Power gating control
    // This would be connected to a power controller in a real design
    wire power_gate = 1'b0;  // Normally off, can be controlled dynamically
endmodule