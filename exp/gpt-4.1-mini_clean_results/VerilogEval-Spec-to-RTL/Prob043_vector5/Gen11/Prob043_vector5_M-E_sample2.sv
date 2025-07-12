module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    reg [24:0] temp_out;

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Calculate bit index to match descending order: out[24 - (i*5 + j)]
                temp_out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end

    assign out = temp_out;

endmodule