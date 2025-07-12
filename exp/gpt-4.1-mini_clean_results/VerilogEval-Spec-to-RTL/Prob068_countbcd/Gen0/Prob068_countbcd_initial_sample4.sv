module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Temporary registers for each digit
    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Default ena to 0, will set as needed
            ena <= 3'b000;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;

                // Enable tens increment
                ena[0] <= 1'b1;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Enable hundreds increment
                    ena[1] <= 1'b1;
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        // Enable thousands increment
                        ena[2] <= 1'b1;
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                        end else begin
                            thousands <= thousands + 4'd1;
                        end
                    end else begin
                        hundreds <= hundreds + 4'd1;
                    end
                end else begin
                    tens <= tens + 4'd1;
                end
            end else begin
                ones <= ones + 4'd1;
            end
            // Update output q
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule