// Define a parameterizable DFF module to handle 8-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Use an always block for the reset condition
always_ff @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};
    end
end

// Use an assign statement for the non-reset condition
assign q = (reset) ? {WIDTH{1'b0}} : d;

// However, the above assign statement won't work as expected because
// q is already being driven by the always block.
// To fix this, we can use a separate register for the non-reset condition.
logic [WIDTH-1:0] q_non_reset;
assign q_non_reset = d;

always_ff @(posedge clk) begin
    if (!reset) begin
        q <= q_non_reset;
    end else begin
        q <= {WIDTH{1'b0}};
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

DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule