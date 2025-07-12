module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit_0;  // ones
    reg [3:0] digit_1;  // tens
    reg [3:0] digit_2;  // hundreds
    reg [3:0] digit_3;  // thousands

    // Enable signals for digit 1, 2, and 3
    assign ena[0] = (digit_0 == 4'd9);
    assign ena[1] = (digit_0 == 4'd9) && (digit_1 == 4'd9);
    assign ena[2] = (digit_0 == 4'd9) && (digit_1 == 4'd9) && (digit_2 == 4'd9);

    // Combine digits into output
    assign q = {digit_3, digit_2, digit_1, digit_0};

    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
        end
        else begin
            // Increment ones digit
            if (digit_0 == 4'd9) begin
                digit_0 <= 4'd0;
            end
            else begin
                digit_0 <= digit_0 + 4'd1;
            end

            // Increment tens digit if ones rolled over
            if (ena[0]) begin
                if (digit_1 == 4'd9) begin
                    digit_1 <= 4'd0;
                end
                else begin
                    digit_1 <= digit_1 + 4'd1;
                end
            end

            // Increment hundreds digit if tens rolled over
            if (ena[1]) begin
                if (digit_2 == 4'd9) begin
                    digit_2 <= 4'd0;
                end
                else begin
                    digit_2 <= digit_2 + 4'd1;
                end
            end

            // Increment thousands digit if hundreds rolled over
            if (ena[2]) begin
                if (digit_3 == 4'd9) begin
                    digit_3 <= 4'd0;
                end
                else begin
                    digit_3 <= digit_3 + 4'd1;
                end
            end
        end
    end

endmodule