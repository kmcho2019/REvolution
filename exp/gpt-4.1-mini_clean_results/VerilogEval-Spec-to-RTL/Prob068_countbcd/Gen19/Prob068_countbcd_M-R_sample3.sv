module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands
    reg [3:0] next_digits [3:0];

    // Compute enable signals combinationally from current digits
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = ena[0] & (digits[1] == 4'd9);
    assign ena[2] = ena[1] & (digits[2] == 4'd9);

    // Combinational logic to compute next digits based on current digits and carry ripple
    always @(*) begin
        // Ones digit increment and carry generation
        if (digits[0] == 4'd9) begin
            next_digits[0] = 4'd0;
            // Tens digit
            if (digits[1] == 4'd9) begin
                next_digits[1] = 4'd0;
                // Hundreds digit
                if (digits[2] == 4'd9) begin
                    next_digits[2] = 4'd0;
                    // Thousands digit
                    next_digits[3] = (digits[3] == 4'd9) ? 4'd0 : digits[3] + 1;
                end else begin
                    next_digits[2] = digits[2] + 1;
                    next_digits[3] = digits[3];
                end
            end else begin
                next_digits[1] = digits[1] + 1;
                next_digits[2] = digits[2];
                next_digits[3] = digits[3];
            end
        end else begin
            next_digits[0] = digits[0] + 1;
            next_digits[1] = digits[1];
            next_digits[2] = digits[2];
            next_digits[3] = digits[3];
        end
    end

    // Sequential logic for register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            digits[0] <= next_digits[0];
            digits[1] <= next_digits[1];
            digits[2] <= next_digits[2];
            digits[3] <= next_digits[3];
        end
    end

    // Concatenate digits into 16-bit output q
    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule