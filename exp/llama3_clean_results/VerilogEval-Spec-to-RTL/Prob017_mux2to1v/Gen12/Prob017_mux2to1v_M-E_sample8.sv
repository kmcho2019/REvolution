// Module TopModule implements a 2-1 multiplexer design using a hierarchical tree structure.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Define the number of bits per segment
parameter SEGMENT_SIZE = 4;

// Calculate the number of segments
parameter NUM_SEGMENTS = 100 / SEGMENT_SIZE;

// Internal wires to hold the segment-wise selection
wire [SEGMENT_SIZE-1:0] segment_out [NUM_SEGMENTS-1:0];

// Generate the multiplexer tree
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i++) begin
        // Select between corresponding segments of 'a' and 'b' based on 'sel'
        assign segment_out[i] = sel ? b[(i+1)*SEGMENT_SIZE-1:i*SEGMENT_SIZE] : a[(i+1)*SEGMENT_SIZE-1:i*SEGMENT_SIZE];
    end
endgenerate

// Combine the segment-wise selections to form the final output
assign out = {segment_out[NUM_SEGMENTS-1], segment_out[NUM_SEGMENTS-2], segment_out[NUM_SEGMENTS-3], segment_out[NUM_SEGMENTS-4],
              segment_out[NUM_SEGMENTS-5], segment_out[NUM_SEGMENTS-6], segment_out[NUM_SEGMENTS-7], segment_out[NUM_SEGMENTS-8],
              segment_out[NUM_SEGMENTS-9], segment_out[NUM_SEGMENTS-10], segment_out[NUM_SEGMENTS-11], segment_out[NUM_SEGMENTS-12],
              segment_out[NUM_SEGMENTS-13], segment_out[NUM_SEGMENTS-14], segment_out[NUM_SEGMENTS-15], segment_out[NUM_SEGMENTS-16],
              segment_out[NUM_SEGMENTS-17], segment_out[NUM_SEGMENTS-18], segment_out[NUM_SEGMENTS-19], segment_out[NUM_SEGMENTS-20],
              segment_out[NUM_SEGMENTS-21], segment_out[NUM_SEGMENTS-22], segment_out[NUM_SEGMENTS-23], segment_out[NUM_SEGMENTS-24],
              segment_out[NUM_SEGMENTS-25]};

endmodule