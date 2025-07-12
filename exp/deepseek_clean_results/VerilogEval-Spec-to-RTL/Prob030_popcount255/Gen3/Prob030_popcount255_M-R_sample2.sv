module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Break into 5 groups of 51 bits each (255 total)
    wire [5:0] count0 = in[50:0] + in[101:51] + in[152:102];
    wire [5:0] count1 = in[203:153] + in[254:204];
    
    // Sum all partial counts
    assign out = count0 + count1;

endmodule