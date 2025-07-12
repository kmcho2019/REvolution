module DFF_VectorSyncReset #(
    parameter WIDTH = 8
) (
    input  wire               clk,
    input  wire               reset,
    input  wire [WIDTH-1:0]   d,
    output reg  [WIDTH-1:0]   q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    DFF_VectorSyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule