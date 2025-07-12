module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;
reg [3:0] counter;

always @(*) begin
    if (counter == 0) begin
        quotient = 0;
        remainder = A;
        divisor = B;
    end else if (counter < 9) begin
        if (remainder[15:8] >= divisor) begin
            quotient[15-counter+8] = 1;
            remainder[15:8] = remainder[15:8] - divisor;
        end
        remainder = {remainder[14:0], A[15-counter]};
    end else begin
        if (remainder[15:8] >= divisor) begin
            quotient[15-counter+8] = 1;
            remainder[15:8] = remainder[15:8] - divisor;
        end
        remainder = {remainder[14:0], 1'b0};
    end
end

always @(posedge counter) begin
    if (counter < 16) begin
        counter <= counter + 1;
    end else begin
        counter <= 0;
        result <= quotient;
        odd <= {8'd0, remainder[7:0]};
    end
end

always @(negedge counter) begin
    counter <= 0;
end

initial begin
    counter = 1;
end

endmodule