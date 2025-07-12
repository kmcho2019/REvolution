module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [7:0] remainder;
    reg [15:0] quotient;
    reg [8:0] current;

    integer i;
    always @* begin
        current = {1'b0, A[15]};
        quotient[15] = (current >= {1'b0, B});
        current = quotient[15] ? (current - B) : current;

        for (i = 14; i >= 0; i = i - 1) begin
            current = {current[7:0], A[i]};
            quotient[i] = (current >= {1'b0, B});
            current = quotient[i] ? (current - B) : current;
        end

        remainder = current[7:0];
    end

    assign result = quotient;
    assign odd = {8'b0, remainder};

endmodule