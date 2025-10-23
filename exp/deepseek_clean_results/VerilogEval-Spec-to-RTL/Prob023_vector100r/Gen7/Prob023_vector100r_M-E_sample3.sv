module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Local function to reverse any size vector
    function automatic [9:0] reverse_chunk(input [9:0] data);
        reverse_chunk = {data[0], data[1], data[2], data[3], data[4], 
                         data[5], data[6], data[7], data[8], data[9]};
    endfunction

    // Reverse each 10-bit chunk
    wire [9:0] reversed_chunks [0:9];
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_reversal
            assign reversed_chunks[i] = reverse_chunk(in[i*10 +: 10]);
        end
    endgenerate

    // Reverse the order of chunks
    assign out = {reversed_chunks[0], reversed_chunks[1], reversed_chunks[2],
                 reversed_chunks[3], reversed_chunks[4], reversed_chunks[5],
                 reversed_chunks[6], reversed_chunks[7], reversed_chunks[8],
                 reversed_chunks[9]};

endmodule