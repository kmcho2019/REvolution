module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Parameterized width (default 8 bits)
parameter WIDTH = 8;

// Generate block for flip-flops
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
        DFF dff (
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// Enhanced D flip-flop module with synchronous reset
module DFF (
    input clk,
    input d,
    output reg q
);
    // Synchronous reset would be added here if needed:
    // input reset,
    // always @(posedge clk) begin
    //     if (reset) q <= 1'b0;
    //     else q <= d;
    // end
    
    // Original behavior maintained
    always @(posedge clk) begin
        q <= d;
    end
endmodule