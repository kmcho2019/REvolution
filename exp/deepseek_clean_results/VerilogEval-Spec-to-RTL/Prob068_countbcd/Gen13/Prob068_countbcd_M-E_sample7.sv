module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];

    // BCD correction logic
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);

    // Enable signals for upper digits
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow & tens_overflow;
    assign ena[2] = ones_overflow & tens_overflow & hundreds_overflow;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Increment the counter
            counter <= counter + 16'd1;
            
            // BCD correction for each digit
            if (ones == 4'd9) begin
                counter[3:0] <= 4'd0;
                if (tens == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    if (hundreds == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        if (thousands == 4'd9) begin
                            counter[15:12] <= 4'd0;
                        end
                    end
                end
            end
        end
    end

    assign q = counter;

endmodule