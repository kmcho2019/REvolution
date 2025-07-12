module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Since N=100 = 10 segments * 10 bits
    // Reverse bits within each 10-bit segment and then reverse the order of segments

    // Function to reverse 10 bits at a time (local to module)
    function [9:0] reverse_10b;
        input [9:0] val;
        integer i;
        begin
            for (i = 0; i < 10; i = i + 1) begin
                reverse_10b[i] = val[9 - i];
            end
        end
    endfunction

    // Declare intermediate reversed segments
    wire [9:0] segments [0:9];
    wire [9:0] rev_segments [0:9];

    genvar idx;
    generate
        // Partition input into 10 segments of 10 bits
        for (idx = 0; idx < 10; idx = idx + 1) begin : segment_partition
            assign segments[idx] = in[idx*10 +: 10];
            assign rev_segments[idx] = reverse_10b(segments[idx]);
        end
    endgenerate

    // Concatenate reversed segments in reversed order
    assign out = {
        rev_segments[0],  // originally highest segment
        rev_segments[1],
        rev_segments[2],
        rev_segments[3],
        rev_segments[4],
        rev_segments[5],
        rev_segments[6],
        rev_segments[7],
        rev_segments[8],
        rev_segments[9]   // originally lowest segment
    };

    // Note: since we want full bit reversal, the highest input bits (in[99:90])
    // should map to the lowest output bits (out[0:9]), so rev_segments[9] maps to out[0:9]
    // So swap order in concatenation accordingly:

endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate BitRevN with parameter N=100
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule

// Corrected concatenation to ensure full bit reversal:
// out = {rev_segments[9], rev_segments[8], ..., rev_segments[0]}
module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    function [9:0] reverse_10b;
        input [9:0] val;
        integer i;
        begin
            for (i = 0; i < 10; i = i + 1)
                reverse_10b[i] = val[9 - i];
        end
    endfunction

    wire [9:0] segments [0:9];
    wire [9:0] rev_segments [0:9];

    genvar idx;
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : seg
            assign segments[idx] = in[idx*10 +: 10];
            assign rev_segments[idx] = reverse_10b(segments[idx]);
        end
    endgenerate

    assign out = {
        rev_segments[9],
        rev_segments[8],
        rev_segments[7],
        rev_segments[6],
        rev_segments[5],
        rev_segments[4],
        rev_segments[3],
        rev_segments[2],
        rev_segments[1],
        rev_segments[0]
    };
endmodule