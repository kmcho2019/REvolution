module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal registers for each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena      <= 3'b000;
        end else begin
            // Default ena signals
            ena <= 3'b000;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena[0] <= 1'b1;  // Enable increment for tens

                // Increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena[1] <= 1'b1;  // Enable increment for hundreds

                    // Increment hundreds digit
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        ena[2] <= 1'b1;  // Enable increment for thousands

                        // Increment thousands digit
                        if (thousands == 4'd9)
                            thousands <= 4'd0;
                        else
                            thousands <= thousands + 1'b1;
                    end else begin
                        hundreds <= hundreds + 1'b1;
                    end
                end else begin
                    tens <= tens + 1'b1;
                end
            end else begin
                ones <= ones + 1'b1;
            end
        end
    end

    // Combine digits into 16-bit output q
    always @(*) begin
        q = {thousands, hundreds, tens, ones};
    end

endmodule