module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    reg [15:0] prod;
    integer i;

    always @(*) begin
        prod = 16'b0;
        for (i = 0; i < 8; i = i + 1)
            if (B[i]) prod = prod + (A << i);
    end

    assign product = prod;

endmodule