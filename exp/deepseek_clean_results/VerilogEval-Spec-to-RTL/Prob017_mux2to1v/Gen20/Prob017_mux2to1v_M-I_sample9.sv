module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Parameterized segment size (20 bits x 5 segments)
    parameter SEGMENT_SIZE = 20;
    parameter NUM_SEGMENTS = 5;

    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin : mux_segment
            if (i < NUM_SEGMENTS-1) begin
                // Full segments
                always @(*) begin
                    if (sel)
                        out[i*SEGMENT_SIZE +: SEGMENT_SIZE] = b[i*SEGMENT_SIZE +: SEGMENT_SIZE];
                    else
                        out[i*SEGMENT_SIZE +: SEGMENT_SIZE] = a[i*SEGMENT_SIZE +: SEGMENT_SIZE];
                end
            end else begin
                // Last segment handles remaining bits (20 bits in this case)
                always @(*) begin
                    if (sel)
                        out[i*SEGMENT_SIZE +: 100-i*SEGMENT_SIZE] = b[i*SEGMENT_SIZE +: 100-i*SEGMENT_SIZE];
                    else
                        out[i*SEGMENT_SIZE +: 100-i*SEGMENT_SIZE] = a[i*SEGMENT_SIZE +: 100-i*SEGMENT_SIZE];
                end
            end
        end
    endgenerate

endmodule