module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    parameter BCD_LIMIT = 4'd9;
    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Shared comparison logic
    wire ones_max = (ones == BCD_LIMIT);
    wire tens_max = (tens == BCD_LIMIT);
    wire hundreds_max = (hundreds == BCD_LIMIT);

    // Next digit values
    reg [3:0] next_ones;
    reg [3:0] next_tens;
    reg [3:0] next_hundreds;
    reg [3:0] next_thousands;

    always @(*) begin
        // Default next values (no increment)
        next_ones = ones;
        next_tens = tens;
        next_hundreds = hundreds;
        next_thousands = thousands;

        // Ones digit logic
        if (ones_max) begin
            next_ones = 4'd0;
        end else begin
            next_ones = ones + 4'd1;
        end

        // Tens digit logic
        if (ones_max) begin
            if (tens_max) begin
                next_tens = 4'd0;
            end else begin
                next_tens = tens + 4'd1;
            end
        end

        // Hundreds digit logic
        if (ones_max && tens_max) begin
            if (hundreds_max) begin
                next_hundreds = 4'd0;
            end else begin
                next_hundreds = hundreds + 4'd1;
            end
        end

        // Thousands digit logic
        if (ones_max && tens_max && hundreds_max) begin
            if (thousands == BCD_LIMIT) begin
                next_thousands = 4'd0;
            end else begin
                next_thousands = thousands + 4'd1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
            // Registered enable signals
            ena[0] <= ones_max;
            ena[1] <= ones_max && tens_max;
            ena[2] <= ones_max && tens_max && hundreds_max;
        end
    end

endmodule