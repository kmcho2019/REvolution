`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,
    parameter STAGES = 3  // Must be odd number >=3
) (
    output reg clk = 0
);

// Calculate individual stage delay (ps precision)
localparam STAGE_DELAY = (PERIOD*500)/STAGES;

// Internal oscillator nodes
wire [STAGES:0] osc_nodes;

// Create the ring oscillator with programmable delays
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : delay_chain
        if (i == 0) begin
            // First element gets initial kick
            assign #(STAGE_DELAY) osc_nodes[i] = ~osc_nodes[STAGES];
        end else begin
            assign #(STAGE_DELAY) osc_nodes[i] = ~osc_nodes[i-1];
        end
    end
endgenerate

// Close the loop
assign osc_nodes[STAGES] = osc_nodes[STAGES-1];

// Sample the output
always @(osc_nodes[STAGES-1]) begin
    clk <= osc_nodes[STAGES-1];
end

// Initial kick to start oscillation
initial begin
    force osc_nodes[0] = 1;
    #1 release osc_nodes[0];
end

endmodule