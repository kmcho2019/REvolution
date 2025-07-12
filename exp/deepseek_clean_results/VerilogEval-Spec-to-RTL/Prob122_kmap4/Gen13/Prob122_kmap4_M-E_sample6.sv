module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Alternative parity calculation approach
    wire ac_parity = a ^ c;
    wire bd_parity = b ^ d;
    assign out = ac_parity ^ bd_parity;

endmodule