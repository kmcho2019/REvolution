module clkgenerator #(
    parameter PERIOD = 10,
    parameter DELAY_STEPS = 5  // Number of delay elements per half-period
)(
    output wire clk
);

    // Calculate required delay per element
    localparam DELAY_PER_ELEMENT = PERIOD/(2*DELAY_STEPS);
    
    // Delay chain with XOR feedback
    wire [DELAY_STEPS:0] delay_chain;
    assign delay_chain[0] = ~delay_chain[DELAY_STEPS];
    
    // Generate the delay elements
    genvar i;
    generate
        for (i = 0; i < DELAY_STEPS; i = i + 1) begin : delay_chain_gen
            // Each element contributes DELAY_PER_ELEMENT time units
            assign #DELAY_PER_ELEMENT delay_chain[i+1] = delay_chain[i];
        end
    endgenerate
    
    // Output the clock signal
    assign clk = delay_chain[DELAY_STEPS];
    
    // Initialization pulse
    initial begin
        force delay_chain[0] = 0;
        #1 release delay_chain[0];
    end

endmodule