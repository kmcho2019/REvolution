// Define a parameterizable register module with parallel load capability
module ParallelLoadRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Use a single always_ff block to minimize area and power consumption
always_ff @(posedge clk) begin
    if (reset) q <= {WIDTH{1'b0}};
    else q <= d;
end

endmodule

// Instantiate the ParallelLoadRegister module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use the parameterizable ParallelLoadRegister module to maintain flexibility and maintainability
ParallelLoadRegister #(.WIDTH(8)) reg(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule