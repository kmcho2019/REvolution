module DFF_sync_reset #(
    parameter WIDTH = 1
) (
    input                   clk,
    input                   reset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output  [7:0]   q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dffs
            DFF_sync_reset #(.WIDTH(1)) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule