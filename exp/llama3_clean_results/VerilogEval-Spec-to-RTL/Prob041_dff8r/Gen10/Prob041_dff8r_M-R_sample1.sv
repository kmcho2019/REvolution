// Refactored DFF module with direct assignment for reset condition
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Directly assign the reset condition to simplify the logic
always_ff @(posedge clk) begin
    if (reset) q <= {WIDTH{1'b0}};
    else q <= d;
end

endmodule

// Instantiate the refactored DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule