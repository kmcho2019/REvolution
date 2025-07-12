module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg tens_en, hundreds_en, thousands_en;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;

            ena       <= 3'b000;
            q         <= 16'd0;
        end else begin
            // Increment ones digit always
            if (ones == 4'd9) begin
                ones <= 4'd0;
                tens_en = 1'b1;  // carry from ones to tens
            end else begin
                ones <= ones + 1'b1;
                tens_en = 1'b0;
            end

            // Increment tens digit if carry from ones
            if (tens_en) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    hundreds_en = 1'b1; // carry from tens to hundreds
                end else begin
                    tens <= tens + 1'b1;
                    hundreds_en = 1'b0;
                end
            end else begin
                tens <= tens;
                hundreds_en = 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (hundreds_en) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    thousands_en = 1'b1; // carry from hundreds to thousands
                end else begin
                    hundreds <= hundreds + 1'b1;
                    thousands_en = 1'b0;
                end
            end else begin
                hundreds <= hundreds;
                thousands_en = 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (thousands_en) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0; // roll over after 9999
                end else begin
                    thousands <= thousands + 1'b1;
                end
            end else begin
                thousands <= thousands;
            end

            // Set ena output signals for digit increments except ones
            ena[0] <= tens_en;
            ena[1] <= hundreds_en;
            ena[2] <= thousands_en;

            // Assemble output q from updated digits
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule