// Module to reverse the bit ordering of an input vector using multiplexers and demultiplexers
module TopModule(
    input  [7:0] in,  // Input vector
    output [7:0] out  // Output vector
);

    // Define the number of stages required to reverse the input vector
    localparam NUM_STAGES = $clog2(8);

    // Initialize the output vector with the input vector
    wire [7:0] stage_out [NUM_STAGES];
    assign stage_out[0] = in;

    // Cascade multiplexers and demultiplexers to reverse the input vector
    genvar i;
    generate
        for (i = 0; i < NUM_STAGES; i++) begin
            // Create a multiplexer and demultiplexer pair to swap two bits
            wire [7:0] stage_in;
            assign stage_in = stage_out[i];
            wire [7:0] swapped_bits;
            always @(stage_in) begin
                swapped_bits[7-i] = stage_in[i];
                swapped_bits[i] = stage_in[7-i];
                swapped_bits[7:8-i] = stage_in[7:8-i];
                swapped_bits[0:i-1] = stage_in[0:i-1];
            end
            // Assign the output of the current stage to the input of the next stage
            if (i < NUM_STAGES - 1) begin
                assign stage_out[i+1] = swapped_bits;
            end else begin
                assign out = swapped_bits;
            end
        end
    endgenerate

endmodule