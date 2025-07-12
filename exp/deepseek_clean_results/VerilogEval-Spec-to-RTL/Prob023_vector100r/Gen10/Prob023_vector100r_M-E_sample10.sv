module Reverse10 (
    input  [9:0] in,
    output [9:0] out
);
    assign out = {in[0], in[1], in[2], in[3], in[4], 
                 in[5], in[6], in[7], in[8], in[9]};
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    wire [9:0] reversed_segments [9:0];
    
    // Generate 10 instances to reverse each 10-bit segment
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : reverse_blocks
            Reverse10 rev_inst (
                .in (in[i*10 +: 10]),
                .out(reversed_segments[i])
            );
        end
    endgenerate
    
    // Concatenate the reversed segments in reverse order
    assign out = {reversed_segments[9], reversed_segments[8], reversed_segments[7],
                 reversed_segments[6], reversed_segments[5], reversed_segments[4],
                 reversed_segments[3], reversed_segments[2], reversed_segments[1],
                 reversed_segments[0]};
endmodule