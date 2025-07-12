module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shift register for neighbor relationships
    wire [99:0] left_neighbor = {in[0], in[99:1]};  // Circular left shift
    wire [99:0] right_neighbor = {in[98:0], in[99]}; // Circular right shift

    // Main processing
    assign out_both = {1'b0, in[98:0] & left_neighbor[98:0]};  // Explicit boundary
    assign out_any = {right_neighbor[99:1] | in[99:1], 1'b0};  // Explicit boundary
    
    // Wrap-around difference using circular shift
    assign out_different = in ^ left_neighbor;

    // Alternative implementation using generate for clarity
    /*
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : proc
            // Calculate left neighbor index with wrap-around
            localparam left = (i == 99) ? 0 : i + 1;
            
            assign out_both[i] = (i == 99) ? 1'b0 : in[i] & in[i+1];
            assign out_any[i] = (i == 0) ? 1'b0 : in[i] | in[i-1];
            assign out_different[i] = in[i] ^ in[left];
        end
    endgenerate
    */
endmodule