module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Digit values
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];

    // Enable conditions
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);

    // Enable signals
    assign ena[0] = ones_max;                      // Tens enable
    assign ena[1] = ones_max & tens_max;           // Hundreds enable
    assign ena[2] = ones_max & tens_max & hundreds_max; // Thousands enable

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Increment ones digit always
            if (ones == 4'd9) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= ones + 4'd1;
            end

            // Conditional increment for higher digits
            if (ena[0] && (tens == 4'd9)) begin
                counter[7:4] <= 4'd0;
            end else if (ena[0]) begin
                counter[7:4] <= tens + 4'd1;
            end

            if (ena[1] && (hundreds == 4'd9)) begin
                counter[11:8] <= 4'd0;
            end else if (ena[1]) begin
                counter[11:8] <= hundreds + 4'd1;
            end

            if (ena[2] && (thousands == 4'd9)) begin
                counter[15:12] <= 4'd0;
            end else if (ena[2]) begin
                counter[15:12] <= thousands + 4'd1;
            end
        end
    end

    assign q = counter;

endmodule