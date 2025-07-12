module TopModule (
    input        clk,
    input        reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal carry flags for each digit increment
    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
            carry_ones <= 1'b0;
            carry_tens <= 1'b0;
            carry_hundreds <= 1'b0;
        end else begin
            // Extract digits from q
            reg [3:0] ones, tens, hundreds, thousands;
            ones     = q[3:0];
            tens     = q[7:4];
            hundreds = q[11:8];
            thousands= q[15:12];

            // Initialize enables low
            ena = 3'b000;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones = 4'd0;
                carry_ones = 1'b1;
                ena[0] = 1'b1;
            end else begin
                ones = ones + 1'b1;
                carry_ones = 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    tens = 4'd0;
                    carry_tens = 1'b1;
                    ena[1] = 1'b1;
                end else begin
                    tens = tens + 1'b1;
                    carry_tens = 1'b0;
                end
            end else begin
                carry_tens = 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds = 4'd0;
                    carry_hundreds = 1'b1;
                    ena[2] = 1'b1;
                end else begin
                    hundreds = hundreds + 1'b1;
                    carry_hundreds = 1'b0;
                end
            end else begin
                carry_hundreds = 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands = 4'd0;
                end else begin
                    thousands = thousands + 1'b1;
                end
            end

            // Pack digits back into q
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule