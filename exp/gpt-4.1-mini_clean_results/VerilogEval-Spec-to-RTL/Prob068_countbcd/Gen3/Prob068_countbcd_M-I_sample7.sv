module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Next values for digits
    reg [3:0] next_digits [3:0];
    // Carry signals between digits
    wire carry0, carry1, carry2;

    // Calculate next digits and carry out combinationally
    // ones digit always increments by 1
    always @* begin
        // Ones digit increment and carry
        if (digits[0] == 4'd9) begin
            next_digits[0] = 4'd0;
            // carry to tens
            // carry0 = 1'b1;
        end else begin
            next_digits[0] = digits[0] + 4'd1;
            // carry0 = 1'b0;
        end

        // Carry from ones digit
        // carry0 is 1 if ones digit rolls over from 9 to 0
    end

    assign carry0 = (digits[0] == 4'd9);

    // tens digit increment enabled only if carry0 = 1
    always @* begin
        if (carry0) begin
            if (digits[1] == 4'd9) begin
                next_digits[1] = 4'd0;
                // carry1 = 1'b1;
            end else begin
                next_digits[1] = digits[1] + 4'd1;
                // carry1 = 1'b0;
            end
        end else begin
            next_digits[1] = digits[1];
            // carry1 = 1'b0;
        end
    end

    assign carry1 = (carry0 && (digits[1] == 4'd9));

    // hundreds digit increment enabled only if carry1 = 1
    always @* begin
        if (carry1) begin
            if (digits[2] == 4'd9) begin
                next_digits[2] = 4'd0;
                // carry2 = 1'b1;
            end else begin
                next_digits[2] = digits[2] + 4'd1;
                // carry2 = 1'b0;
            end
        end else begin
            next_digits[2] = digits[2];
            // carry2 = 1'b0;
        end
    end

    assign carry2 = (carry1 && (digits[2] == 4'd9));

    // thousands digit increment enabled only if carry2 = 1
    always @* begin
        if (carry2) begin
            if (digits[3] == 4'd9) begin
                next_digits[3] = 4'd0;
            end else begin
                next_digits[3] = digits[3] + 4'd1;
            end
        end else begin
            next_digits[3] = digits[3];
        end
    end

    // Synchronous update of digits and ena on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
            ena <= 3'b0;
            q <= 16'd0;
        end else begin
            digits[0] <= next_digits[0];
            digits[1] <= next_digits[1];
            digits[2] <= next_digits[2];
            digits[3] <= next_digits[3];
            // ena bits correspond to increments of tens, hundreds, thousands digits
            ena <= {carry2, carry1, carry0};
            // Pack digits into output q
            q <= {digits[3], digits[2], digits[1], digits[0]};
        end
    end

endmodule