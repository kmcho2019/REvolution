// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    // Use a generate block to instantiate the DFFs
    generate
        for (genvar i = 0; i < WIDTH; i++) begin
            // Use a non-blocking assignment to reduce switching activity
            always_ff @(posedge clk) begin
                if (reset) begin
                    q[i] <= 1'b0;
                end else begin
                    q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule

// Instantiate the DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use a clock gating cell to reduce power consumption
logic gated_clk;
always_comb begin
    gated_clk = clk & ~reset;
end

DFF #(.WIDTH(8)) dff(
   .clk(gated_clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule