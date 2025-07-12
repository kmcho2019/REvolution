module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] full_sum;

    assign full_sum = a + b + cin;
    assign sum = full_sum[7:0];
    assign cout = full_sum[8];

endmodule