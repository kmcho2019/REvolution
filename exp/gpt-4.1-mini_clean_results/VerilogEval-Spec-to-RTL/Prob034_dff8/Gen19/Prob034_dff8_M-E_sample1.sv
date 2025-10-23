module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

    // Internal wires to connect DFF outputs
    wire [7:0] q_internal;

    // Generate block to create eight D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q_internal[i])
            );
        end
    endgenerate

    // Assign internal registered outputs to output port
    assign q = q_internal;

endmodule


// Single bit D flip-flop module
module DFF (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule