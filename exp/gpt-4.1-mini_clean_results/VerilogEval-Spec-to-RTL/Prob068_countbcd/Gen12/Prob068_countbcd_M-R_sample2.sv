module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count, bcd_next;

    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Enable signals: each asserted when the lower digit is 9, indicating carry to next digit
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Combinational logic to compute next BCD count
    always @* begin
        // Start increment ones digit
        reg carry_ones, carry_tens, carry_hundreds, carry_thousands;
        reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;

        // Increment ones digit
        if (ones == 4'd9) begin
            next_ones  = 4'd0;
            carry_ones = 1'b1;
        end else begin
            next_ones  = ones + 1;
            carry_ones = 1'b0;
        end

        // Increment tens digit if ones rolled over
        if (carry_ones) begin
            if (tens == 4'd9) begin
                next_tens  = 4'd0;
                carry_tens = 1'b1;
            end else begin
                next_tens  = tens + 1;
                carry_tens = 1'b0;
            end
        end else begin
            next_tens = tens;
            carry_tens = 1'b0;
        end

        // Increment hundreds digit if tens rolled over
        if (carry_tens) begin
            if (hundreds == 4'd9) begin
                next_hundreds  = 4'd0;
                carry_hundreds = 1'b1;
            end else begin
                next_hundreds  = hundreds + 1;
                carry_hundreds = 1'b0;
            end
        end else begin
            next_hundreds = hundreds;
            carry_hundreds = 1'b0;
        end

        // Increment thousands digit if hundreds rolled over
        if (carry_hundreds) begin
            if (thousands == 4'd9) begin
                next_thousands = 4'd0;
                carry_thousands = 1'b1; // optional, wraps around at 9999
            end else begin
                next_thousands = thousands + 1;
                carry_thousands = 1'b0;
            end
        end else begin
            next_thousands = thousands;
            carry_thousands = 1'b0;
        end

        bcd_next = {next_thousands, next_hundreds, next_tens, next_ones};
    end

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= bcd_next;
        end
    end

    assign q = bcd_count;

endmodule