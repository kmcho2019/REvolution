module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    wire [15:0] A_ext = {8'b0, A};
    reg  [15:0] prod;

    integer i;
    always @(*) begin
        prod = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                prod = prod + (A_ext << i);
        end
    end

    assign product = prod;

endmodule