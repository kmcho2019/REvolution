module DFF_1bit_sync_reset (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module DFF_VectorSyncReset #(
    parameter WIDTH = 8
) (
    input  wire                  clk,
    input  wire                  reset,
    input  wire [WIDTH-1:0]      d,
    output wire [WIDTH-1:0]      q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_bits
            DFF_1bit_sync_reset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    DFF_VectorSyncReset #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule