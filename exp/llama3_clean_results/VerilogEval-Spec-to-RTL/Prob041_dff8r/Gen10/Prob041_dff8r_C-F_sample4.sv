// Define a parameterizable DFF module with clock gating
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input clk_enable, // Clock enable signal for clock gating
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic gated_clk; // Gated clock signal

// Clock gate: only enable the clock when clk_enable is high
assign gated_clk = clk & clk_enable;

// Use a generate block to instantiate the DFFs
generate
    for (genvar i = 0; i < WIDTH; i++) begin
        always_ff @(posedge gated_clk) begin
            if (reset) begin
                // Reset the flip-flop to 0 on the positive edge of the gated clock when reset is high
                q[i] <= 1'b0;
            end else begin
                // Otherwise, load the input 'd' into the flip-flop on the positive edge of the gated clock
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule

// Define the TopModule that instantiates the DFF module
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Additional logic to control the clock enable based on operational modes or activity
// For simplicity, assume the clock enable is always active
logic clk_enable = 1'b1;

// Instantiate the DFF module with its inputs and output connected appropriately
DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .clk_enable(clk_enable), // Pass the clock enable signal
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule