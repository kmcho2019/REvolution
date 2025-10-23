// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Define the number of bits per segment
parameter SEGMENT_BITS = 8;

// Calculate the number of segments
parameter NUM_SEGMENTS = 64 / SEGMENT_BITS;

// Define the segment module
module segment_module(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    input [SEGMENT_BITS-1:0] in,  // Input from the previous segment
    output reg [SEGMENT_BITS-1:0] out  // Output of the current segment
);

    // Always block for sequential logic
    always @(posedge clk or negedge rst_n) begin
        // Reset condition: Set out to 0 when rst_n is low
        if (~rst_n) begin
            out <= {SEGMENT_BITS{1'b0}};
        end else begin
            // Update out based on the current state (in)
            // If in[0] is 1, shift right and append 0; otherwise, shift right and append 1
            out <= {~in[0], in[SEGMENT_BITS-1:1]};
        end
    end

endmodule

// Instantiate the segment modules
wire [SEGMENT_BITS-1:0] segment_out [NUM_SEGMENTS-1:0];
reg [SEGMENT_BITS-1:0] segment_in [NUM_SEGMENTS:0];

// Set the initial input to the first segment
assign segment_in[0] = 8'd0;

// Connect the segments
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i++) begin
        segment_module segment_inst(
            .clk(clk),
            .rst_n(rst_n),
            .in(segment_in[i]),
            .out(segment_out[i])
        );
        
        // Connect the output of the current segment to the input of the next segment
        assign segment_in[i+1] = segment_out[i];
    end
endgenerate

// Assign the final output
assign Q = {segment_out[NUM_SEGMENTS-1], segment_out[NUM_SEGMENTS-2], segment_out[NUM_SEGMENTS-3], segment_out[NUM_SEGMENTS-4], segment_out[NUM_SEGMENTS-5], segment_out[NUM_SEGMENTS-6], segment_out[NUM_SEGMENTS-7]};

endmodule