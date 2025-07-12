module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    // Array to hold inputs indexed 0..4 = {a,b,c,d,e}
    reg [4:0] inputs_reg;

    integer i, j;
    reg [24:0] temp_out;

    always @(*) begin
        // Pack inputs into array
        inputs_reg[0] = a;
        inputs_reg[1] = b;
        inputs_reg[2] = c;
        inputs_reg[3] = d;
        inputs_reg[4] = e;

        // Compute pairwise equality bits
        // bit index = 24 - (5*i + j), inputs index = i,j
        for (i = 0; i < 5; i = i +1) begin
            for (j = 0; j < 5; j = j +1) begin
                temp_out[24 - (5*i + j)] = ~(inputs_reg[i] ^ inputs_reg[j]); // XNOR
            end
        end

        // Assign computed bits to output
        out = temp_out;
    end

endmodule