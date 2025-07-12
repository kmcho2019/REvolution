module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute the binary sum of A, B, and Cin
    wire [4:0] binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Use a look-up table to map the binary sum to the BCD output
    always @(*) begin
        case (binary_sum)
            5'd0:   {Sum, Cout} = 5'd0;
            5'd1:   {Sum, Cout} = 5'd1;
            5'd2:   {Sum, Cout} = 5'd2;
            5'd3:   {Sum, Cout} = 5'd3;
            5'd4:   {Sum, Cout} = 5'd4;
            5'd5:   {Sum, Cout} = 5'd5;
            5'd6:   {Sum, Cout} = 5'd6;
            5'd7:   {Sum, Cout} = 5'd7;
            5'd8:   {Sum, Cout} = 5'd8;
            5'd9:   {Sum, Cout} = 5'd9;
            5'd10:  {Sum, Cout} = 5'd0;  // 10 in binary is 1010, maps to 0 in BCD with carry
            5'd11:  {Sum, Cout} = 5'd1;  // 11 in binary is 1011, maps to 1 in BCD with carry
            5'd12:  {Sum, Cout} = 5'd2;  // 12 in binary is 1100, maps to 2 in BCD with carry
            5'd13:  {Sum, Cout} = 5'd3;  // 13 in binary is 1101, maps to 3 in BCD with carry
            5'd14:  {Sum, Cout} = 5'd4;  // 14 in binary is 1110, maps to 4 in BCD with carry
            5'd15:  {Sum, Cout} = 5'd5;  // 15 in binary is 1111, maps to 5 in BCD with carry
            5'd16:  {Sum, Cout} = 5'd6;  // 16 in binary is 10000, maps to 6 in BCD with carry
            5'd17:  {Sum, Cout} = 5'd7;  // 17 in binary is 10001, maps to 7 in BCD with carry
            5'd18:  {Sum, Cout} = 5'd8;  // 18 in binary is 10010, maps to 8 in BCD with carry
            5'd19:  {Sum, Cout} = 5'd9;  // 19 in binary is 10011, maps to 9 in BCD with carry
            default: {Sum, Cout} = 5'd0;  // Default case to ensure no unknown values
        endcase
    end

endmodule