module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    assign temp_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if sum exceeds 9 and apply correction if necessary
    always @(*) begin
        if (temp_sum > 9) begin
            // Add correction value of 6
            Sum = temp_sum[3:0] + 4'b0110;
            // Set carry-out to 1
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = temp_sum[3:0];
            // Set carry-out to 0
            Cout = 1'b0;
        end
    end

endmodule