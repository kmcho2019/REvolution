// Module to reverse the bit ordering of an 8-bit input using bitwise operations
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Internal wires to hold the reversed bits
    reg [7:0] reversed;

    // Initialize the reversed bits to 0
    initial begin
        reversed = 8'b0;
    end

    // Reverse the bits using bitwise operations
    always @(*) begin
        reversed = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
        reversed = {reversed[7], reversed[6], reversed[5], reversed[4], reversed[3], reversed[2], reversed[1], reversed[0]};
    end

    // Output the reversed bits
    assign out = reversed;

endmodule