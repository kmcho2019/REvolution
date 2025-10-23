module TopModule (
    input  a,
    input  b,
    input  cin,
    output reg cout,
    output reg sum
);

    always @(*) begin
        // 2-bit vector to hold the sum of inputs
        reg [1:0] total;
        total = a + b + cin;
        sum = total[0];
        cout = total[1];
    end

endmodule