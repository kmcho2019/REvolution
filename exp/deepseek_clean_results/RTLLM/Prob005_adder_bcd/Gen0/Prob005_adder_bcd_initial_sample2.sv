module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

reg [4:0] temp_sum;  // 5-bit to hold carry during addition

always @(*) begin
    // Step 1: Perform binary addition
    temp_sum = A + B + Cin;
    
    // Step 2: Check if correction needed (sum > 9) or carry generated
    if (temp_sum > 9 || temp_sum[4] == 1'b1) begin
        // Step 3: Apply BCD correction (add 6) and set carry
        Sum = temp_sum[3:0] + 6;
        Cout = 1'b1;
    end
    else begin
        // Step 4: No correction needed
        Sum = temp_sum[3:0];
        Cout = 1'b0;
    end
end

endmodule