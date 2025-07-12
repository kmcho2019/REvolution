module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] raw_sum = A + B + Cin;
    wire correction = (raw_sum > 9) || (A + B + Cin > 15);

    always @(*) begin
        {Cout, Sum} = correction ? {1'b1, raw_sum + 4'b0110} : {1'b0, raw_sum};
    end

endmodule