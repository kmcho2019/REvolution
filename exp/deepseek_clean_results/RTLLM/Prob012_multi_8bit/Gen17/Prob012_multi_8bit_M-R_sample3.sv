module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    reg [15:0] accumulator;
    integer i;

    always @(*) begin
        multiplicand = {8'b0, A};  // Zero-extend multiplicand
        accumulator = 16'b0;       // Initialize accumulator

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                accumulator = accumulator + (multiplicand << i);
            end
        end

        product = accumulator;
    end

endmodule