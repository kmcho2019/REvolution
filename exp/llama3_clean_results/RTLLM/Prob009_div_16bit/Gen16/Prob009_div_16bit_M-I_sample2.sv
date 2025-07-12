module div_16bit(
    input clk,
    input rst,
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;
reg [3:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        quotient <= 0;
        remainder <= 0;
        divisor <= 0;
        counter <= 0;
        result <= 0;
        odd <= 0;
    end else if (A == 0 || B == 0) begin
        quotient <= 0;
        remainder <= A;
        result <= 0;
        odd <= A;
    end else begin
        if (counter == 0) begin
            quotient <= 0;
            remainder <= A;
            divisor <= B;
        end else if (counter < 16) begin
            if (remainder[15:8] >= divisor) begin
                quotient[15-counter] <= 1;
                remainder <= {remainder[14:0], remainder[15]} - {divisor, 8'd0};
            end else begin
                quotient[15-counter] <= 0;
                remainder <= {remainder[14:0], remainder[15]};
            end
            counter <= counter + 1;
        end else begin
            result <= quotient;
            odd <= {8'd0, remainder[7:0]};
            counter <= 0;
        end
    end
end

endmodule