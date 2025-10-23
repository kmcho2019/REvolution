module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Single-bit D flip-flop with synchronous reset
module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset) q <= 1'b0;
        else q <= d;
    end
endmodule

// Generate 8 instances of the DFF
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule