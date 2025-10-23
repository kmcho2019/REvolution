module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Concatenate inputs into a vector for easy indexed access
    wire [4:0] inputs = {a, b, c, d, e};  // inputs[4]=a ... inputs[0]=e (little-endian order)

    reg [24:0] temp_out;
    integer i, j;

    always @(*) begin
        // Fill temp_out in ascending order: out[0] = compare inputs[0],inputs[0]
        // The mapping is row-major: for i in 0..4 (rows), j in 0..4 (cols)
        // out[(i*5)+j] = ~(inputs[i] ^ inputs[j])
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                temp_out[(i*5)+j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end

    // Assign the output with this vector (bit 0 is inputs[0],inputs[0], bit 24 is inputs[4],inputs[4])
    assign out = temp_out;

endmodule