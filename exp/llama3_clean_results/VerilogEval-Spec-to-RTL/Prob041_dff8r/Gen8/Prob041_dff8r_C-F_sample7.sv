// Define a parameterizable DFF module to handle 8-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};
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

logic clk_gated;

// Clock gating to reduce power consumption
always_ff @(posedge clk) begin
    if (reset) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= 1'b1;
    end
end

DFF #(.WIDTH(8)) dff(
   .clk(clk_gated),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule