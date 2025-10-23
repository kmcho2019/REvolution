module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Optional power gating control (disabled by default)
// parameter POWER_GATING = 0;
// wire power_enable = 1'b1;  // Normally tied high

// Reset distribution network with balanced buffers
wire reset_sync;
reset_buf u_reset_buf (.A(areset), .Z(reset_sync));

// Optional scan chain signals (commented out)
// input scan_en;
// input scan_in;
// output scan_out;
// wire scan_out_chain;

genvar i;
generate
    for (i=0; i<8; i=i+1) begin : dff_gen
        // Individual DFF with explicit instantiation
        dff_ar u_dff (
            .clk(clk),
            .reset(reset_sync),
            .d(d[i]),
            .q(q[i])
            // Optional scan connections
            // .scan_en(scan_en),
            // .scan_in(i==0 ? scan_in : dff_gen[i-1].scan_out),
            // .scan_out(i==7 ? scan_out : dff_gen[i+1].scan_in)
        );
    end
endgenerate

// Optional scan output assignment
// assign scan_out = dff_gen[7].scan_out;

endmodule

// Custom DFF with asynchronous reset
module dff_ar (
    input clk,
    input reset,
    input d,
    output reg q
    // Optional scan ports
    // input scan_en,
    // input scan_in,
    // output scan_out
);
always @(posedge clk or posedge reset) begin
    if (reset) q <= 1'b0;
    else q <= d;
    // Optional scan mux
    // else q <= scan_en ? scan_in : d;
end
// assign scan_out = q;
endmodule

// Reset buffer for balanced distribution
module reset_buf (input A, output Z);
assign Z = A;  // In real implementation would use library buffer cells
endmodule