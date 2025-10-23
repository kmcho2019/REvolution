// Module to reverse the bit ordering of an 8-bit input using a loop
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a loop to reverse the bits
    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            out[i] = in[7 - i];
        end
    end

endmodule