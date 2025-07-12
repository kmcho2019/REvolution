module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);
    // Inputs vector arranged so that inputs[4]=a down to inputs[0]=e
    wire [4:0] inputs = {e, d, c, b, a};

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Use same mapping: bit index = (4 - i)*5 + (4 - j)
                out[(4 - i)*5 + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end
endmodule