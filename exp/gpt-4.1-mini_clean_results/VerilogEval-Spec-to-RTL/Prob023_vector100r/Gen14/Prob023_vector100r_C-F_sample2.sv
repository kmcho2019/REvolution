module BitRevN #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Function to reverse bits of input vector
    function [N-1:0] reverse_bits;
        input [N-1:0] data;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1) begin
                reverse_bits[i] = data[N-1 - i];
            end
        end
    endfunction

    assign out = reverse_bits(in);
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Break input into 10 segments of 10 bits each
    wire [9:0] segments_in [9:0];
    wire [9:0] segments_out [9:0];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_processing
            assign segments_in[i] = in[i*10 +: 10];
            BitRevN #(10) bitrev10_inst (
                .in(segments_in[i]),
                .out(segments_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reverse order to form the output
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_concat
            assign out[(i*10) +: 10] = segments_out[9 - i];
        end
    endgenerate

endmodule