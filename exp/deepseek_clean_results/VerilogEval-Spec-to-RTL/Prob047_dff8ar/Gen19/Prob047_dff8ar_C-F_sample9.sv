module DFF_AR #(parameter WIDTH = 1) (
    input clk,
    input areset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= {WIDTH{1'b0}};  // Vectorized reset to 0
    end
    else begin
        q <= d;              // Positive edge-triggered update
    end
end

endmodule

module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

DFF_AR #(.WIDTH(8)) dff_array (
    .clk(clk),
    .areset(areset),
    .d(d),
    .q(q)
);

endmodule