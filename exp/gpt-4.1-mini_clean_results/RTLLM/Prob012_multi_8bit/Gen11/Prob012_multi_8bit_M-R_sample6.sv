module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Temporary variable to hold the combinational product
    reg [15:0] temp_product;
    integer i;

    always @(*) begin
        temp_product = 16'b0;
        // Loop over each bit of B and add shifted A if that bit is set
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                temp_product = temp_product + (A << i);
        end
    end

    assign product = temp_product;

endmodule