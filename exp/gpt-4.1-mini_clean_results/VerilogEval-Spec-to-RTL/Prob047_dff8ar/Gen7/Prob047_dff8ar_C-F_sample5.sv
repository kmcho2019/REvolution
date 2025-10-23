module DFF8_async_reset (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output reg [7:0] q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate the 8-bit asynchronous reset register
    DFF8_async_reset dff8_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule