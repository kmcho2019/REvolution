module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameterized function with hierarchical reversal
function automatic [99:0] reverse_bits;
    input [99:0] data;
    integer i, j;
    localparam SEGMENT_SIZE = 10;
    localparam NUM_SEGMENTS = 100/SEGMENT_SIZE;
    begin
        // Reverse segment order and bits within segments in one pass
        for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin
            for (j = 0; j < SEGMENT_SIZE; j = j + 1) begin
                reverse_bits[i*SEGMENT_SIZE + j] = 
                    data[(NUM_SEGMENTS-1-i)*SEGMENT_SIZE + (SEGMENT_SIZE-1-j)];
            end
        end
    end
endfunction

assign out = reverse_bits(in);

endmodule