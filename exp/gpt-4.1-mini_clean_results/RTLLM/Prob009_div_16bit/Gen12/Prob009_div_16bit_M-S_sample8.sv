module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        integer i;
        reg [8:0] remainder = 9'd0;
        reg [15:0] quotient = 16'd0;
        reg [8:0] divisor_ext = {1'b0, b_reg};

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else
                quotient[i] = 1'b0;
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end

endmodule