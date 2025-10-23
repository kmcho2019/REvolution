module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    wire [4:0] in_vec = {a,b,c,d,e};
    integer i, j;

    always @(*) begin
        // Build out bits in row-major order with out[24] = eq(a,a), down to out[0] = eq(e,e)
        for(i=0; i<5; i=i+1) begin
            for(j=0; j<5; j=j+1) begin
                out[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    end
endmodule