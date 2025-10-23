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

    // Apply BCD correction if sum exceeds 9
    always @(*) begin
        if (sum_wire > 9) begin
            Sum = sum_wire + 6;
            Cout = 1;
        end else begin
            Sum = sum_wire[3:0]; // Assign the lower 4 bits of sum_wire to Sum
            Cout = sum_wire[4];  // Assign the most significant bit of sum_wire to Cout
        end
    end

endmodule