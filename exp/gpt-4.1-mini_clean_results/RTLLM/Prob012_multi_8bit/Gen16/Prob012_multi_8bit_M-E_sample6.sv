module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    reg [15:0] partial_sum;

    always @(*) begin
        partial_sum = 16'b0;
        // Iterate through each bit of B
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                // Add shifted A to partial_sum when bit i of B is set
                partial_sum = partial_sum + ( {8'b0, A} << i );
            end
        end
        product = partial_sum;
    end

endmodule