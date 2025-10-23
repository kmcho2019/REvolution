module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Create a temporary array to hold the reversed bytes
    wire [7:0] reversed_bytes [0:3];
    
    // Use a generate block to reverse the byte order
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reversal
            assign reversed_bytes[i] = in[(3-i)*8 +: 8];
        end
    endgenerate
    
    // Concatenate the reversed bytes to form the output
    assign out = {reversed_bytes[0], reversed_bytes[1], 
                  reversed_bytes[2], reversed_bytes[3]};
endmodule