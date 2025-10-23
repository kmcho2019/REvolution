// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Use a separate always block for the reset condition to optimize timing
always @(posedge clk) begin
    if (reset) q <= 0;
end

// Use another always block for the D flip-flop operation
always @(posedge clk) begin
    if (!reset) q <= d;
end

endmodule

// Alternatively, a single always block with a priority assignment can be used for better timing
// module DFF #(parameter WIDTH = 8)(input clk, input reset, input [WIDTH-1:0] d, output logic [WIDTH-1:0] q);
// always_ff @(posedge clk) begin
//     q <= reset ? 0 : d;
// end
// endmodule

// Instantiate the DFF module within the TopModule
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