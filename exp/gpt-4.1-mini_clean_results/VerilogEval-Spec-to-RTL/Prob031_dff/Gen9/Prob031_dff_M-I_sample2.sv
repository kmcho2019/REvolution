// D flip-flop with conditional load to avoid unnecessary toggling for power optimization
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (d != q) begin
            q <= d;
        end
    end
endmodule

// Top-level module instantiating the optimized DFF
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule