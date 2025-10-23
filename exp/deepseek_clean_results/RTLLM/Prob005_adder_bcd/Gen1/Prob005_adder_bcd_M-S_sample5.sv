module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

wire [4:0] raw_sum = A + B + Cin;

always @(*) begin
    // Check if correction needed (sum > 9 or carry generated)
    if (raw_sum > 9) begin
        Sum = raw_sum[3:0] + 4'd6;  // Add 6 and keep 4 bits
        Cout = 1'b1;
    end
    else begin
        Sum = raw_sum[3:0];
        Cout = raw_sum[4];
    end
end

endmodule