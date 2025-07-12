module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    // Pre-extend multiplicand to 16 bits (zero-extended)
    wire [15:0] A_ext = {8'b0, A};

    integer i;
    always @(*) begin
        product = 16'b0;
        // Shift-and-add multiplication
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product = product + (A_ext << i);
        end
    end

endmodule