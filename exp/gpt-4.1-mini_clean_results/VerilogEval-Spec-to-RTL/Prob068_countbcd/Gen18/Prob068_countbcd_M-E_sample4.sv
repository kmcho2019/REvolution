module TopModule (
    input         clk,
    input         reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg tens_en, hundreds_en, thousands_en;

    // Increment ones digit every clock cycle (unless reset)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else if (ones == 4'd9) begin
            ones <= 4'd0;
        end else begin
            ones <= ones + 4'd1;
        end
    end

    // Enable tens to increment when ones rolls over (from 9 to 0)
    always @(posedge clk) begin
        if (reset) begin
            tens_en <= 1'b0;
        end else begin
            tens_en <= (ones == 4'd9);
        end
    end

    // Increment tens digit when enabled
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (tens_en) begin
            if (tens == 4'd9)
                tens <= 4'd0;
            else
                tens <= tens + 4'd1;
        end
    end

    // Enable hundreds to increment when tens rolls over
    always @(posedge clk) begin
        if (reset) begin
            hundreds_en <= 1'b0;
        end else begin
            hundreds_en <= tens_en & (tens == 4'd9);
        end
    end

    // Increment hundreds digit when enabled
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (hundreds_en) begin
            if (hundreds == 4'd9)
                hundreds <= 4'd0;
            else
                hundreds <= hundreds + 4'd1;
        end
    end

    // Enable thousands to increment when hundreds rolls over
    always @(posedge clk) begin
        if (reset) begin
            thousands_en <= 1'b0;
        end else begin
            thousands_en <= hundreds_en & (hundreds == 4'd9);
        end
    end

    // Increment thousands digit when enabled
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (thousands_en) begin
            if (thousands == 4'd9)
                thousands <= 4'd0;
            else
                thousands <= thousands + 4'd1;
        end
    end

    // Output concatenated digits
    always @(*) begin
        q = {thousands, hundreds, tens, ones};
    end

    // Output enable signals for digits [3:1] in ena[2:0]
    // ena[0] = tens_en, ena[1] = hundreds_en, ena[2] = thousands_en
    always @(*) begin
        ena = {thousands_en, hundreds_en, tens_en};
    end

endmodule