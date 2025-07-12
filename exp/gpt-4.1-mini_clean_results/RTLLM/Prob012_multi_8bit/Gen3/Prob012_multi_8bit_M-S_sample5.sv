module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    integer i;
    reg [15:0] result;

    always @(*) begin
        result = 16'b0;
        for (i = 0; i < 8; i = i + 1)
            if (B[i])
                result = result + (A << i);
    end

    assign product = result;

endmodule