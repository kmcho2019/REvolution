module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

integer i, j;
reg [4:0] signal;

always @(a, b, c, d, e) begin
    signal[0] = a;
    signal[1] = b;
    signal[2] = c;
    signal[3] = d;
    signal[4] = e;
    for(i = 0; i < 5; i = i + 1) begin
        for(j = i; j < 5; j = j + 1) begin
            out[i*5 + j - (i*(i+1)/2)] = ~(signal[i] ^ signal[j]);
        end
    end
end

endmodule