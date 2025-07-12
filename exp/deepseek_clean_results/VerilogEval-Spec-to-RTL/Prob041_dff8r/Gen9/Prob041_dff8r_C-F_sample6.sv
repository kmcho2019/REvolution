// Single D Flip-Flop with synchronous reset
module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset) q <= 1'b0;  // Synchronous reset
        else       q <= d;      // Normal operation
    end
endmodule

// Parameterized register module
module TopModule #(
    parameter WIDTH = 8  // Default width of 8 bits
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Generate block to instantiate WIDTH DFFs
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule