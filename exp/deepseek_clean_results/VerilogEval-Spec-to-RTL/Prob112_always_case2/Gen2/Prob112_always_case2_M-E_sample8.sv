module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // First level: Process each 2-bit pair
    wire [1:0] pair1_valid_pos;
    wire [1:0] pair2_valid_pos;
    
    // Pair 1 (bits 3 and 2)
    assign pair1_valid_pos[1] = in[3] | in[2];  // Valid if either bit is high
    assign pair1_valid_pos[0] = in[3] ? 1'b1 : 1'b0;  // Position within pair
    
    // Pair 2 (bits 1 and 0)
    assign pair2_valid_pos[1] = in[1] | in[0];  // Valid if either bit is high
    assign pair2_valid_pos[0] = in[1] ? 1'b1 : 1'b0;  // Position within pair
    
    // Second level: Combine pairs
    wire use_pair1 = pair1_valid_pos[1];
    wire [1:0] final_pos;
    
    assign final_pos[1] = use_pair1 ? 1'b1 : (pair2_valid_pos[1] ? 1'b0 : 1'b0);
    assign final_pos[0] = use_pair1 ? pair1_valid_pos[0] : pair2_valid_pos[0];
    
    // Output: Handle all-zeros case
    assign pos = (|in) ? final_pos : 2'b00;

endmodule