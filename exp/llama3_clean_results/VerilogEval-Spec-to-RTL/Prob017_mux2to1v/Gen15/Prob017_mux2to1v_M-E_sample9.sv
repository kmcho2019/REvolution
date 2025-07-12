// Novel architectural solution for a 2-1 multiplexer
// This module selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// The approach involves dividing the inputs into smaller segments and implementing a multiplexer at each level.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Define the segment size for the tree-based structure
localparam SEGMENT_SIZE = 4;

// Calculate the number of segments required
localparam NUM_SEGMENTS = 100 / SEGMENT_SIZE;

// Define the multiplexer module for each segment
module segment_mux(
    input [SEGMENT_SIZE-1:0] a,  // Segment of input 'a'
    input [SEGMENT_SIZE-1:0] b,  // Segment of input 'b'
    input sel,                   // Select line
    output [SEGMENT_SIZE-1:0] out // Segment of output
);
    // Implement the multiplexer logic for the segment
    always_comb begin
        if (sel) begin
            out = b;
        end else begin
            out = a;
        end
    end
endmodule

// Instantiate the segment multiplexers and connect them to form the 100-bit output
genvar i;
for (i = 0; i < NUM_SEGMENTS; i++) begin
    // Calculate the start and end indices for the current segment
    localparam START_IDX = i * SEGMENT_SIZE;
    localparam END_IDX = (i + 1) * SEGMENT_SIZE - 1;

    // Instantiate the segment multiplexer
    segment_mux u_segment_mux(
        .a(a[END_IDX:START_IDX]),  // Segment of input 'a'
        .b(b[END_IDX:START_IDX]),  // Segment of input 'b'
        .sel(sel),                 // Select line
        .out(out[END_IDX:START_IDX]) // Segment of output
    );
end

endmodule