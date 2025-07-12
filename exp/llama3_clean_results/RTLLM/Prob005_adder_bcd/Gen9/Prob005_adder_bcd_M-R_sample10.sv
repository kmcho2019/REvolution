module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum_internal;
    reg cout_internal;

    always @(*) begin
        // Calculate the binary sum
        reg [4:0] bin_sum = A + B + Cin;

        // Apply BCD correction if the sum exceeds 9
        if (bin_sum > 9) begin
            sum_internal = bin_sum[3:0] + 6;
            cout_internal = 1'b1;
        end else begin
            sum_internal = bin_sum[3:0];
            cout_internal = 1'b0;
        end
    end

    // Assign outputs
    assign Sum = sum_internal;
    assign Cout = cout_internal;

endmodule