module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [3:0] bit_counter;
    reg [15:0] accumulator;

    always @(*) begin
        // Initialize values
        multiplicand = A;
        multiplier = B;
        accumulator = 16'b0;
        bit_counter = 4'b0;

        // Process each bit of the multiplier
        for (bit_counter = 0; bit_counter < 8; bit_counter = bit_counter + 1) begin
            if (multiplier[bit_counter]) begin
                accumulator = accumulator + (multiplicand << bit_counter);
            end
        end

        // Assign final product
        product = accumulator;
    end

endmodule