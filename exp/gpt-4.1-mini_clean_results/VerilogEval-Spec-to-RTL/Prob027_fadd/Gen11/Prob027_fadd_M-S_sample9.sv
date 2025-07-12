module TopModule(input a,b,cin, output cout,sum);
    assign {cout,sum} = {(a&b)|(b&cin)|(a&cin), a^b^cin};
endmodule