module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract current digits
    wire [3:0] ones     = q[3:0];
    wire [3:0] tens     = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands= q[15:12];

    // Combinational logic to determine carry and next digit values
    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    reg carry_ones, carry_tens, carry_hundreds;

    always @(*) begin
        // Increment ones digit
        if (ones == 4'd9) begin
            next_ones = 4'd0;
            carry_ones = 1'b1;
        end else begin
            next_ones = ones + 1;
            carry_ones = 1'b0;
        end

        // Increment tens digit if carry from ones
        if (carry_ones) begin
            if (tens == 4'd9) begin
                next_tens = 4'd0;
                carry_tens = 1'b1;
            end else begin
                next_tens = tens + 1;
                carry_tens = 1'b0;
            end
        end else begin
            next_tens = tens;
            carry_tens = 1'b0;
        end

        // Increment hundreds digit if carry from tens
        if (carry_tens) begin
            if (hundreds == 4'd9) begin
                next_hundreds = 4'd0;
                carry_hundreds = 1'b1;
            end else begin
                next_hundreds = hundreds + 1;
                carry_hundreds = 1'b0;
            end
        end else begin
            next_hundreds = hundreds;
            carry_hundreds = 1'b0;
        end

        // Increment thousands digit if carry from hundreds
        if (carry_hundreds) begin
            if (thousands == 4'd9) begin
                next_thousands = 4'd0;
            end else begin
                next_thousands = thousands + 1;
            end
        end else begin
            next_thousands = thousands;
        end
    end

    // Sequential logic for register update and ena output
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
            ena <= {carry_hundreds, carry_tens, carry_ones};
            // ena[0] -> tens enable (carry_ones)
            // ena[1] -> hundreds enable (carry_tens)
            // ena[2] -> thousands enable (carry_hundreds)
        end
    end

endmodule