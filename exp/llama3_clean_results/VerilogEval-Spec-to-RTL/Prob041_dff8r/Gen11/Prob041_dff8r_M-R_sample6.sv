// Define a parameterizable DFF module with clock gating
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Implement the DFF with a simple always_ff block and assign for combinational logic
always_ff @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};
    end else begin
        q <= d;
    end
end

endmodule

// Define the TopModule that instantiates the DFF module
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Directly instantiate the DFF module without the unnecessary clock enable signal
DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule