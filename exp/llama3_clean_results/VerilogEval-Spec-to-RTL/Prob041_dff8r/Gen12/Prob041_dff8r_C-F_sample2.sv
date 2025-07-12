// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input clk_en, // Clock enable signal
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    // Use a generate block to instantiate the DFFs
    generate
        for (genvar i = 0; i < WIDTH; i++) begin
            always_ff @(posedge clk) begin
                if (reset) begin
                    q[i] <= 1'b0;
                end else if (clk_en) begin
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

logic clk_en; // Clock enable signal

// Generate clock enable signal
assign clk_en = 1'b1; // Enable clock always, or use a signal that indicates when the clock should be enabled

DFF #(.WIDTH(8)) dff(
   .clk(clk),
   .reset(reset),
   .clk_en(clk_en),
   .d(d),
   .q(q)
);

endmodule