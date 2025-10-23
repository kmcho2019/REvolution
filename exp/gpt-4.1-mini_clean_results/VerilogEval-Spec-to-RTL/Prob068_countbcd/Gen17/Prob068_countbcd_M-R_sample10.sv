module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3; // Ones, Tens, Hundreds, Thousands digits
    wire carry0, carry1, carry2;

    // Calculate carry signals: carry occurs when digit rolls over from 9 to 0
    assign carry0 = (digit0 == 4'd9);
    assign carry1 = (digit1 == 4'd9);
    assign carry2 = (digit2 == 4'd9);

    // Enables for upper digits correspond to when the lower digit wraps from 9 to 0
    assign ena[0] = carry0;              // Enable tens digit
    assign ena[1] = carry0 && carry1;   // Enable hundreds digit
    assign ena[2] = carry0 && carry1 && carry2; // Enable thousands digit

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Increment ones digit
            if (digit0 == 4'd9)
                digit0 <= 4'd0;
            else
                digit0 <= digit0 + 4'd1;

            // Increment tens digit if enabled
            if (carry0) begin
                if (digit1 == 4'd9)
                    digit1 <= 4'd0;
                else
                    digit1 <= digit1 + 4'd1;
            end

            // Increment hundreds digit if enabled
            if (carry0 && carry1) begin
                if (digit2 == 4'd9)
                    digit2 <= 4'd0;
                else
                    digit2 <= digit2 + 4'd1;
            end

            // Increment thousands digit if enabled
            if (carry0 && carry1 && carry2) begin
                if (digit3 == 4'd9)
                    digit3 <= 4'd0;
                else
                    digit3 <= digit3 + 4'd1;
            end
        end
    end

    assign q = {digit3, digit2, digit1, digit0};

endmodule