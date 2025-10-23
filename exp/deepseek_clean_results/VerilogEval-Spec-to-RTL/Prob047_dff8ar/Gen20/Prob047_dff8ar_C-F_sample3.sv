module DFF_AR #(parameter WIDTH = 1) (
    input clk,
    input areset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= {WIDTH{1'b0}};  // Efficient vectorized reset
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

// Instantiate parameterized DFF_AR with generate loop
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF_AR #(.WIDTH(1)) dff (
            .clk(clk),
            .areset(areset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule