module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // 4:1 MUX implementation for sum (a^b)
    wire [3:0] mux_in_sum;
    assign mux_in_sum = {1'b0, 1'b1, 1'b1, 1'b0}; // Truth table for XOR
    assign sum = mux_in_sum[{a,b}];  // Using a and b as select lines

    // 2:1 MUX implementation for cout (a&b)
    wire [1:0] mux_in_cout;
    assign mux_in_cout = {1'b0, 1'b1}; // Truth table for AND (only b matters when a=1)
    assign cout = a ? mux_in_cout[b] : 1'b0;
endmodule