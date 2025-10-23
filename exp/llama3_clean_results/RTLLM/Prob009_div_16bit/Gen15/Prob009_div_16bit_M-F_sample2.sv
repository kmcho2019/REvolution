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

// Initialize values
always @(*) begin
    if (A == 0 || B == 0) begin
        quotient = 0;
        remainder = A;
    end else begin
        quotient = 0;
        remainder = A;
        divisor = B;
    end
end

// Perform division
always @(*) begin
    if (counter == 0) begin
        // Initialize remainder and quotient
        remainder = A;
        quotient = 0;
    end else if (counter < 16) begin
        // Compare and subtract
        if (remainder[15:8] >= divisor) begin
            quotient[15-counter] = 1;
            remainder[15:8] = remainder[15:8] - divisor;
        end
        // Shift remainder
        remainder = {remainder[14:0], remainder[15]};
    end else begin
        // Output result
        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end
end

// Counter logic
always @(*) begin
    if (counter < 16) begin
        counter <= counter + 1;
    end else begin
        counter <= 0;
    end
end

initial begin
    counter = 0;
end

endmodule