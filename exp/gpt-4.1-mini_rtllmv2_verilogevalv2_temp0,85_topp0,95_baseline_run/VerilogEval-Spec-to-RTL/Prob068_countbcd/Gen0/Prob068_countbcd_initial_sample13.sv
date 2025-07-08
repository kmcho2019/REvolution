module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires for digits
    reg [3:0] digit0, digit1, digit2, digit3; // ones, tens, hundreds, thousands

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            ena <= 3'b000; // default disable enables

            // Increment ones digit
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                ena[0] <= 1'b1; // enable tens increment

                // Increment tens digit
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    ena[1] <= 1'b1; // enable hundreds increment

                    // Increment hundreds digit
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;
                        ena[2] <= 1'b1; // enable thousands increment

                        // Increment thousands digit
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0; // wrap around after 9999
                        end else begin
                            digit3 <= digit3 + 4'd1;
                        end
                    end else begin
                        digit2 <= digit2 + 4'd1;
                    end
                end else begin
                    digit1 <= digit1 + 4'd1;
                end
            end else begin
                digit0 <= digit0 + 4'd1;
            end
        end
    end

    // Assign output q
    always @(*) begin
        q = {digit3, digit2, digit1, digit0};
    end

endmodule