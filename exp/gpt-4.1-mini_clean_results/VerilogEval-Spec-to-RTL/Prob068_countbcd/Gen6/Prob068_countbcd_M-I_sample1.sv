module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg tens_en, hundreds_en, thousands_en;

    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    reg tens_en_next, hundreds_en_next, thousands_en_next;

    always @* begin
        // Default no increments to upper digits
        tens_en_next      = 1'b0;
        hundreds_en_next  = 1'b0;
        thousands_en_next = 1'b0;

        // Increment ones digit and check carry
        if (ones == 4'd9) begin
            ones_next = 4'd0;
            tens_en_next = 1'b1;
        end else begin
            ones_next = ones + 1'b1;
            tens_en_next = 1'b0;
        end

        // Increment tens digit if carry from ones
        if (tens_en) begin
            if (tens == 4'd9) begin
                tens_next = 4'd0;
                hundreds_en_next = 1'b1;
            end else begin
                tens_next = tens + 1'b1;
                hundreds_en_next = 1'b0;
            end
        end else begin
            tens_next = tens;
            hundreds_en_next = 1'b0;
        end

        // Increment hundreds digit if carry from tens
        if (hundreds_en) begin
            if (hundreds == 4'd9) begin
                hundreds_next = 4'd0;
                thousands_en_next = 1'b1;
            end else begin
                hundreds_next = hundreds + 1'b1;
                thousands_en_next = 1'b0;
            end
        end else begin
            hundreds_next = hundreds;
            thousands_en_next = 1'b0;
        end

        // Increment thousands digit if carry from hundreds
        if (thousands_en) begin
            if (thousands == 4'd9) begin
                thousands_next = 4'd0; // roll over after 9999
            end else begin
                thousands_next = thousands + 1'b1;
            end
        end else begin
            thousands_next = thousands;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;

            tens_en     <= 1'b0;
            hundreds_en <= 1'b0;
            thousands_en <= 1'b0;

            ena        <= 3'b000;
            q          <= 16'd0;
        end else begin
            ones      <= ones_next;
            tens      <= tens_next;
            hundreds  <= hundreds_next;
            thousands <= thousands_next;

            tens_en     <= tens_en_next;
            hundreds_en <= hundreds_en_next;
            thousands_en <= thousands_en_next;

            ena <= {thousands_en, hundreds_en, tens_en};
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule