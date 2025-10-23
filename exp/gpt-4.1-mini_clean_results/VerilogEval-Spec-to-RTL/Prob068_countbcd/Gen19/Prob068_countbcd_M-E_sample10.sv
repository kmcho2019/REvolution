module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3;
    wire carry0, carry1, carry2;

    // Increment ones digit and generate carry if digit rolls over from 9 to 0
    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Ones digit
            if (digit0 == 4'd9)
                digit0 <= 4'd0;
            else
                digit0 <= digit0 + 4'd1;

            // Tens digit
            if (carry0) begin
                if (digit1 == 4'd9)
                    digit1 <= 4'd0;
                else
                    digit1 <= digit1 + 4'd1;
            end

            // Hundreds digit
            if (carry1) begin
                if (digit2 == 4'd9)
                    digit2 <= 4'd0;
                else
                    digit2 <= digit2 + 4'd1;
            end

            // Thousands digit
            if (carry2) begin
                if (digit3 == 4'd9)
                    digit3 <= 4'd0;
                else
                    digit3 <= digit3 + 4'd1;
            end
        end
    end

    // Carry generation: each carry is true when corresponding digit reaches 9 and increments
    assign carry0 = (digit0 == 4'd9);
    assign carry1 = carry0 && (digit1 == 4'd9);
    assign carry2 = carry1 && (digit2 == 4'd9);

    // Enables for digits 3:1 indicate when to increment those digits
    assign ena[0] = carry0; // Enable tens digit increment
    assign ena[1] = carry1; // Enable hundreds digit increment
    assign ena[2] = carry2; // Enable thousands digit increment

    // Combine digits into output q
    assign q = {digit3, digit2, digit1, digit0};

endmodule