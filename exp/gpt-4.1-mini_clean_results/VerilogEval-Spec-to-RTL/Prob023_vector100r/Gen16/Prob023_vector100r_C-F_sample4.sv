module BitRevN #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);

    // Function to reverse bits of the input vector
    function [N-1:0] reverse_bits;
        input [N-1:0] value;
        integer idx;
        begin
            for (idx = 0; idx < N; idx = idx + 1) begin
                reverse_bits[idx] = value[N - 1 - idx];
            end
        end
    endfunction

    // Assign output as reversed input
    assign out = reverse_bits(in);

endmodule


module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Split input into 10 segments of 10 bits each
    wire [9:0] seg_in [0:9];
    wire [9:0] seg_out [0:9];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_split
            assign seg_in[i] = in[i*10 +: 10];
        end
    endgenerate

    // Reverse each 10-bit segment using parameterized BitRevN #(10)
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_reverse
            BitRevN #(10) bitrev_inst (
                .in(seg_in[i]),
                .out(seg_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reversed order to form final output
    generate
        for (i = 0; i < 10; i = i + 1) begin : output_assemble
            assign out[i*10 +: 10] = seg_out[9 - i];
        end
    endgenerate

endmodule