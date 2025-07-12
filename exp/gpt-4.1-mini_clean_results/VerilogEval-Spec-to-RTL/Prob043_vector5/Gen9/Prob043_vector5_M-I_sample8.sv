module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);
    // Inputs reordered to match output indexing: inputs[4]=a, inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // bit index: (4 - i)*5 + (4 - j)
                // Use equality operator for potential better synthesis
                out[(4 - i)*5 + (4 - j)] = (inputs[i] == inputs[j]);
            end
        end
    end
endmodule