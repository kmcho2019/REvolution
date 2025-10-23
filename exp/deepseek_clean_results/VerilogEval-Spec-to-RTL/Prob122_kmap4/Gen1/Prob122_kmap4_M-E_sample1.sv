module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire ab_parity;
    wire cd_parity;
    
    assign ab_parity = a ^ b;
    assign cd_parity = c ^ d;
    assign out = ~(ab_parity ^ cd_parity);
endmodule