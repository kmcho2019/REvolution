// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  wire [7:0] in,  // 8-bit input vector
    output wire [7:0] out // 8-bit output vector
);
    // Use a for-loop to assign the bits of the input to the output in reverse order.
    // This approach can potentially reduce the area usage by minimizing the number of wires and connections required.
    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            out[7-i] = in[i];
        end
    end
endmodule