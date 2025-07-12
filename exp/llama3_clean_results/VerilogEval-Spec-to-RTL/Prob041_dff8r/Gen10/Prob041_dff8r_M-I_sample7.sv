// The provided code is already quite optimized and straightforward.
// Minor adjustments for explicitness and adherence to best practices are applied below.

// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Explicitly handle the reset condition for clarity
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        // Directly set q to 0, equivalent to {WIDTH{1'b0}}
        q <= '0;
    end else begin
        q <= d;
    end
end

endmodule

// Instantiate the DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use the DFF module with the specified width
DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule