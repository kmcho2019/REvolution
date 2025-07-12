// Define a parameterizable low-power DFF module to handle n-bit data
module LP_DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    // Use a generate block to instantiate the low-power DFFs
    generate
        for (genvar i = 0; i < WIDTH; i++) begin
            always_ff @(posedge clk) begin
                if (reset) begin
                    q[i] <= 1'b0;
                end else if (~reset && d[i] == 1'b1) begin
                    q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule

// Instantiate the low-power DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    // Apply clock gating to reduce dynamic power consumption
    logic gated_clk;
    assign gated_clk = clk & ~reset;

    LP_DFF #(.WIDTH(8)) lp_dff(
       .clk(gated_clk),
       .reset(reset),
       .d(d),
       .q(q)
    );

endmodule