module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    // Compute initial sum with carry
    wire [4:0] raw_sum = A + B + Cin;
    
    // Efficient correction detection (sum >9 or carry)
    // Equivalent to: raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction = raw_sum[4] | (&raw_sum[3:2]) | (raw_sum[3] & raw_sum[1]);
    
    // Compute final sum and carry in one operation
    always @(*) begin
        if (correction) begin
            Sum = raw_sum[3:0] + 4'b0110;
            Cout = 1'b1;
        end else begin
            Sum = raw_sum[3:0];
            Cout = raw_sum[4];
        end
    end

endmodule