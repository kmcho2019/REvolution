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

    assign out = reverse_bits(in);

endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Split input into 10 chunks of 10 bits each
    wire [9:0] chunk [0:9];
    wire [9:0] rev_chunk [0:9];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_process
            assign chunk[i] = in[(i+1)*10 - 1 : i*10];
            BitRevN #(.N(10)) bitrev_inst (
                .in(chunk[i]),
                .out(rev_chunk[i])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order to get fully reversed 100-bit vector
    assign out = { rev_chunk[9], rev_chunk[8], rev_chunk[7], rev_chunk[6], rev_chunk[5],
                   rev_chunk[4], rev_chunk[3], rev_chunk[2], rev_chunk[1], rev_chunk[0] };
endmodule