module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    wire [4:0] inputs = {a,b,c,d,e};

    integer i, j;
    always @* begin
        out = 25'b0;
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // bit position: 24 - (i*5 + j)
                out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end
endmodule