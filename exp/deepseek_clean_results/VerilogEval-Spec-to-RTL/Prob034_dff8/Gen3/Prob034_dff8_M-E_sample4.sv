module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Internal wires for the shift chain
    wire [7:0] d_chain;
    
    // Generate 8 DFFs with parallel load capability
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_chain
            // Each DFF has a 2:1 mux for parallel load or shift
            wire mux_out = d[i];  // Always select parallel load in this implementation
            
            // Instantiate individual DFF with enable
            reg dff_out;
            always @(posedge clk) begin
                dff_out <= mux_out;
            end
            
            // Connect output and next stage input
            assign q[i] = dff_out;
            assign d_chain[i] = dff_out;
        end
    endgenerate

endmodule