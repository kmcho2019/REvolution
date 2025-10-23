module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_temp = A + B + Cin;
    
    // Apply BCD correction if sum exceeds 9
    reg [4:0] sum_corrected;
    always @(A or B or Cin) begin
        if (sum_temp > 9) begin
            sum_corrected = sum_temp + 6;
        end else begin
            sum_corrected = sum_temp;
        end
    end

    // Assign Sum and Cout
    assign Sum = sum_corrected[3:0];
    assign Cout = (sum_temp > 9) || (sum_corrected > 9);

endmodule