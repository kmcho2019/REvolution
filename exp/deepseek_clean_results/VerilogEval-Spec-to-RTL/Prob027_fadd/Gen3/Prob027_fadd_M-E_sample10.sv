module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Sum implementation using 4:1 MUX
    // sum = a'b'cin + a'bcin' + ab'cin' + abcin
    assign sum = (a & b) ? cin : 
                (a & ~b) ? ~cin :
                (~a & b) ? ~cin : cin;

    // Carry implementation using 4:1 MUX
    // cout = a'bcin + ab'cin + abcin' + abcin
    assign cout = (a & b) ? 1'b1 :
                 (a & ~b) ? cin :
                 (~a & b) ? cin : 1'b0;

endmodule