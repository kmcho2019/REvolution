module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Individual digits as registers for clarity
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
            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena[0] <= 1'b1; // Enable tens digit increment
            end else begin
                ones <= ones + 1;
                ena[0] <= 1'b0;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena[1] <= 1'b1; // Enable hundreds digit increment
                end else begin
                    tens <= tens + 1;
                    ena[1] <= 1'b0;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena[2] <= 1'b1; // Enable thousands digit increment
                end else begin
                    hundreds <= hundreds + 1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                    // No higher digit, so no enable output beyond ena[2]
                end else begin
                    thousands <= thousands + 1;
                end
            end
        end
    end

    // Assign output concatenation
    always @* begin
        q = {thousands, hundreds, tens, ones};
    end

endmodule