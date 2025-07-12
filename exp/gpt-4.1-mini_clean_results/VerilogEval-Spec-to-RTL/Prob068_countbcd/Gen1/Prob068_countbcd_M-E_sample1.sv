module TopModule(
    input  wire       clk,
    input  wire       reset,
    output reg [2:0]  ena,
    output reg [15:0] q
);

    // Separate digit registers
    reg [3:0] digit0;  // ones
    reg [3:0] digit1;  // tens
    reg [3:0] digit2;  // hundreds
    reg [3:0] digit3;  // thousands

    // Registered carry enable signals for each upper digit
    reg carry_ones_to_tens;
    reg carry_tens_to_hundreds;
    reg carry_hundreds_to_thousands;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset clears all digits and disables
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;

            carry_ones_to_tens     <= 1'b0;
            carry_tens_to_hundreds <= 1'b0;
            carry_hundreds_to_thousands <= 1'b0;

            ena <= 3'b000;
        end else begin
            // Default disables (updated after increments)
            ena <= {carry_hundreds_to_thousands, carry_tens_to_hundreds, carry_ones_to_tens};

            // Increment ones digit always
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                carry_ones_to_tens <= 1'b1;  // signal tens to increment next clock
            end else begin
                digit0 <= digit0 + 4'd1;
                carry_ones_to_tens <= 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry_ones_to_tens) begin
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    carry_tens_to_hundreds <= 1'b1;  // signal hundreds to increment
                end else begin
                    digit1 <= digit1 + 4'd1;
                    carry_tens_to_hundreds <= 1'b0;
                end
            end else begin
                carry_tens_to_hundreds <= 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens_to_hundreds) begin
                if (digit2 == 4'd9) begin
                    digit2 <= 4'd0;
                    carry_hundreds_to_thousands <= 1'b1;  // signal thousands to increment
                end else begin
                    digit2 <= digit2 + 4'd1;
                    carry_hundreds_to_thousands <= 1'b0;
                end
            end else begin
                carry_hundreds_to_thousands <= 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds_to_thousands) begin
                if (digit3 == 4'd9) begin
                    digit3 <= 4'd0;
                end else begin
                    digit3 <= digit3 + 4'd1;
                end
            end
        end
    end

    // Combine digits into q output
    always @(*) begin
        q = {digit3, digit2, digit1, digit0};
    end

endmodule