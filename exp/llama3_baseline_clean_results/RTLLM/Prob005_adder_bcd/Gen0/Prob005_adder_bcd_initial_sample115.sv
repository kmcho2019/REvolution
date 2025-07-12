module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_wire;
    assign sum_wire = A + B + Cin;

    // Check if the sum exceeds 9 and correct it if necessary
    wire [3:0] sum_corrected;
    assign Cout = (sum_wire > 9) ? 1'b1 : 1'b0;

    always @(*) begin
        if (sum_wire > 9) begin
            // Add 6 to the sum to correct it
            sum_corrected = sum_wire + 6;
        end else begin
            sum_corrected = sum_wire[3:0];
        end
    end

    // Assign the corrected sum to the output
    assign Sum = sum_corrected;

endmodule