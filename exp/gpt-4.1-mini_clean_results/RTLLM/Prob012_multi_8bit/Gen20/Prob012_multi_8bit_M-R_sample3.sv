module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);

    integer i;
    reg [15:0] acc;

    always @(*) begin
        acc = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                acc = acc + ( {8'd0, A} << i );
            end
        end
        product = acc;
    end

endmodule