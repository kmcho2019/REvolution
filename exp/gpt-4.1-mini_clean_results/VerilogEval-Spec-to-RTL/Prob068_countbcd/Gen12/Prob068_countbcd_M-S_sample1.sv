module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands
    wire [2:0] en;

    // Generate enable signals: a digit increments when the digit below it equals 9
    assign en[0] = (digits[0] == 4'd9);
    assign en[1] = en[0] & (digits[1] == 4'd9);
    assign en[2] = en[1] & (digits[2] == 4'd9);

    assign ena = en;

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Increment ones digit
            if (digits[0] == 4'd9)
                digits[0] <= 4'd0;
            else
                digits[0] <= digits[0] + 1'b1;

            // Increment tens digit if enabled
            if (en[0]) begin
                if (digits[1] == 4'd9)
                    digits[1] <= 4'd0;
                else
                    digits[1] <= digits[1] + 1'b1;
            end

            // Increment hundreds digit if enabled
            if (en[1]) begin
                if (digits[2] == 4'd9)
                    digits[2] <= 4'd0;
                else
                    digits[2] <= digits[2] + 1'b1;
            end

            // Increment thousands digit if enabled
            if (en[2]) begin
                if (digits[3] == 4'd9)
                    digits[3] <= 4'd0;
                else
                    digits[3] <= digits[3] + 1'b1;
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule