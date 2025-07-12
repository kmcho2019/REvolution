module adder_bcd(
    input  [3:0] A,    // First BCD input (4-bit)
    input  [3:0] B,    // Second BCD input (4-bit)
    input        Cin,  // Carry-in input (1-bit)
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout   // Carry-out output (1-bit)
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_temp; // Temporary sum (5-bit to hold carry)
    assign sum_temp = {1'b0, A} + {1'b0, B} + {3'b0, Cin}; // Binary addition with Cin

    // Check if the sum exceeds 9 and apply correction if necessary
    always @(A or B or Cin) begin
        if (sum_temp > 9) begin // If sum exceeds 9
            Sum = sum_temp + 6; // Apply BCD correction
            Cout = 1'b1;        // Generate carry-out
        end else begin
            Sum = sum_temp[3:0]; // Sum is within BCD range
            Cout = sum_temp[4];  // Carry-out based on sum
        end
    end

endmodule