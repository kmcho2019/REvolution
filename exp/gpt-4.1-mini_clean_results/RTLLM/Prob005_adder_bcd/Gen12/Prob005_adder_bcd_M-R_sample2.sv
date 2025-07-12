module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);

    // Step 1: Initial 5-bit addition of inputs
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Determine if correction is needed (sum > 9)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3 & 4: Use always block to perform conditional BCD correction
    always @* begin
        if (correction_needed) begin
            // Add 6 (0110) for BCD correction
            {Cout, Sum} = raw_sum + 5'd6;
        end else begin
            // No correction needed, direct assignment
            Cout = raw_sum[4];
            Sum  = raw_sum[3:0];
        end
    end

endmodule