module TopModule #(
    parameter NUM_GATES = 2,
    parameter INPUTS_PER_GATE = 4
) (
    input [INPUTS_PER_GATE-1:0] p1,
    input [INPUTS_PER_GATE-1:0] p2,
    output [NUM_GATES-1:0] py
);
    // Pack inputs into arrays for parallel processing
    wire [NUM_GATES*INPUTS_PER_GATE-1:0] all_inputs = {p2, p1};
    
    // Generate NAND outputs in parallel
    genvar i;
    generate
        for (i = 0; i < NUM_GATES; i = i + 1) begin : NAND_GATES
            // Extract the 4 inputs for this gate
            wire [INPUTS_PER_GATE-1:0] gate_inputs = 
                all_inputs[(i+1)*INPUTS_PER_GATE-1 : i*INPUTS_PER_GATE];
            
            // Compute NAND function
            assign py[i] = ~&gate_inputs;
        end
    endgenerate
endmodule