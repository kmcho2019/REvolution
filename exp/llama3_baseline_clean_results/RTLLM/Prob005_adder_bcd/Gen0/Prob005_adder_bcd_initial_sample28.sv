module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal signal for the sum of A, B, and Cin
    reg [4:0] sum_internal;

    // Perform binary addition
    always @(A, B, Cin) begin
        sum_internal = A + B + Cin;
    end

    // BCD correction and carry generation
    always @(sum_internal) begin
        if (sum_internal > 9) begin
            // Apply BCD correction and generate carry
            Sum = sum_internal + 6;
            Cout = 1'b1;
        end else begin
            // No correction needed, no carry generated
            Sum = sum_internal[3:0];
            Cout = 1'b0;
        end
    end

endmodule