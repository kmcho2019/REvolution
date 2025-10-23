module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digit registers
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Default ena signals to 0, will set if increment needed
            ena <= 3'b000;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                // Enable increment tens digit
                ena[0] <= 1'b1;
            end else begin
                ones <= ones + 1'b1;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena[1] <= 1'b1;
                end else begin
                    tens <= tens + 1'b1;
                end
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena[2] <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                end
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end
        end
    end

    // Concatenate all digits into q
    always @(*) begin
        q = {thousands, hundreds, tens, ones};
    end

endmodule