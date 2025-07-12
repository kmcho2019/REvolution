module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] digit_ones;     // 0-9
    reg [3:0] digit_tens;     // 0-9
    reg [3:0] digit_hundreds; // 0-9

    // Combinational calculation of binary count from BCD digits
    wire [13:0] count_value;
    assign count_value = (digit_hundreds * 100) + (digit_tens * 10) + digit_ones;

    always @(posedge clk) begin
        if (reset) begin
            digit_ones <= 4'd0;
            digit_tens <= 4'd0;
            digit_hundreds <= 4'd0;
            q <= 10'd0;
        end else begin
            // Increment ones digit
            if (digit_ones == 4'd9) begin
                digit_ones <= 4'd0;
                // Increment tens digit
                if (digit_tens == 4'd9) begin
                    digit_tens <= 4'd0;
                    // Increment hundreds digit
                    if (digit_hundreds == 4'd9) begin
                        // Roll over all digits
                        digit_hundreds <= 4'd0;
                        q <= 10'd0;
                    end else begin
                        digit_hundreds <= digit_hundreds + 4'd1;
                        q <= count_value + 1;
                    end
                end else begin
                    digit_tens <= digit_tens + 4'd1;
                    q <= count_value + 1;
                end
            end else begin
                digit_ones <= digit_ones + 4'd1;
                q <= count_value + 1;
            end
        end
    end

endmodule