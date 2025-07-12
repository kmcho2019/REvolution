module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Define the segment size for the hierarchical design
    localparam SEG_SIZE = 16;

    // Calculate the number of segments
    localparam NUM_SEGMENTS = 64 / SEG_SIZE;

    // Declare the segment-wise results and carry signals
    wire [NUM_SEGMENTS-1:0] segment_results [SEG_SIZE-1:0];
    wire [NUM_SEGMENTS-1:0] segment_carry;

    // Initialize the carry signal for the first segment
    wire [SEG_SIZE-1:0] init_carry = {SEG_SIZE{1'b0}};

    // Perform the subtraction operation for each segment
    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i++) begin
            // Calculate the segment-wise subtraction
            wire [SEG_SIZE-1:0] segment_A = A[(i*SEG_SIZE)+:SEG_SIZE];
            wire [SEG_SIZE-1:0] segment_B = B[(i*SEG_SIZE)+:SEG_SIZE];

            // Perform the subtraction using a CSA tree
            wire [SEG_SIZE-1:0] segment_diff;
            wire carry_out;
            CSA_tree #(.WIDTH(SEG_SIZE)) csa_tree(
                .A(segment_A),
                .B(~segment_B), // Invert B for subtraction
                .Cin(i == 0 ? 1'b1 : segment_carry[i-1]),
                .S(segment_diff),
                .Cout(carry_out)
            );

            // Store the segment-wise result and carry
            assign segment_results[i] = segment_diff;
            assign segment_carry[i] = carry_out;
        end
    endgenerate

    // Detect the overflow based on the most significant segment
    assign overflow = segment_carry[NUM_SEGMENTS-1];

    // Combine the segment-wise results to form the final result
    assign result = {segment_results[NUM_SEGMENTS-1], segment_results[NUM_SEGMENTS-2], segment_results[NUM_SEGMENTS-3], segment_results[NUM_SEGMENTS-4],
                     segment_results[NUM_SEGMENTS-5], segment_results[NUM_SEGMENTS-6], segment_results[NUM_SEGMENTS-7], segment_results[NUM_SEGMENTS-8],
                     segment_results[NUM_SEGMENTS-9], segment_results[NUM_SEGMENTS-10], segment_results[NUM_SEGMENTS-11], segment_results[NUM_SEGMENTS-12],
                     segment_results[NUM_SEGMENTS-13], segment_results[NUM_SEGMENTS-14], segment_results[NUM_SEGMENTS-15]};

endmodule

// Define the CSA tree module
module CSA_tree #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input Cin,
    output [WIDTH-1:0] S,
    output Cout
);

    // Implement the CSA tree logic
    wire [WIDTH-1:0] sum;
    wire [WIDTH-1:0] carry;

    assign sum = A ^ B;
    assign carry = A & B;

    // Propagate the carry
    assign Cout = (carry[WIDTH-1] | (sum[WIDTH-1] & Cin));

    // Generate the final sum
    assign S = sum ^ {WIDTH{Cin}};

endmodule