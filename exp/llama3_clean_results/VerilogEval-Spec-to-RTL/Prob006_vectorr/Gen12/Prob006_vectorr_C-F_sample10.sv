// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  wire [7:0] in,  // 8-bit input vector
    output wire [7:0] out // 8-bit output vector
);
    // Directly reverse the bit ordering of the input and assign it to the output
    // This approach is straightforward and efficient for the given 8-bit vector.
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
    
    // For larger vectors or different applications, consider alternative methods
    // that could offer better performance, area efficiency, or power consumption.
endmodule