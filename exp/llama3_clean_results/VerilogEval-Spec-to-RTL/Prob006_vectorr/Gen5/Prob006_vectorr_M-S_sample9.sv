module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, a more concise way to achieve the same result:
    // assign out = in[7:0];

    // Or, using bit reversal:
    assign out = in[7:0];

    // However, the most straightforward and simplified way to reverse bits in Verilog is:
    assign out = in[::-1] does not work in Verilog. 
    // Instead, we can use the following syntax which is supported:
    assign out = {>>{in}};

    // Or more simply:
    assign out = {>>8{in}};

endmodule