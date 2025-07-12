module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);
    // Pack inputs into an array for indexed access
    wire [4:0] inputs;
    assign inputs = {e, d, c, b, a}; // Note: bit 4 = e, bit 0 = a

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Calculate output bit index as per specification: bit 24 down to 0
                // The problem maps out[24 - (5*i + j)] to inputs[i] == inputs[j]
                out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end

endmodule