// Basic reset cell - handles one bit with local reset logic
module DFF_R (
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

// Top module using distributed reset cells
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Instantiate 8 DFF_R cells in parallel
    DFF_R bit[7:0] (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule