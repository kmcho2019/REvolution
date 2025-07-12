module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Intermediate sum accumulator
    reg [15:0] sum;
    integer i;

    always @(*) begin
        sum = 16'b0;
        // Iterate over each bit of B; if bit set, add A shifted by bit index
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                sum = sum + (A << i);
        end
    end

    assign product = sum;

endmodule