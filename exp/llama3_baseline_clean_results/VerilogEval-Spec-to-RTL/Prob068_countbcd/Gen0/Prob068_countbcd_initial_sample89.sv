module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal wires for the four 4-bit counters
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Assign the internal wires to the output port q
    assign q = {thousands, hundreds, tens, ones};

    // Initialize the enable signals to 0
    assign ena[0] = (ones == 4'd9)? 1'b1 : 1'b0;
    assign ena[1] = (tens == 4'd9 && ones == 4'd9)? 1'b1 : 1'b0;
    assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9)? 1'b1 : 1'b0;

    // Main sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all counters to 0
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment the ones digit
            if (ones!= 4'd9) begin
                ones <= ones + 1;
            end else begin
                // Wrap around the ones digit and increment the tens digit
                ones <= 4'd0;
                if (tens!= 4'd9) begin
                    tens <= tens + 1;
                end else begin
                    // Wrap around the tens digit and increment the hundreds digit
                    tens <= 4'd0;
                    if (hundreds!= 4'd9) begin
                        hundreds <= hundreds + 1;
                    end else begin
                        // Wrap around the hundreds digit and increment the thousands digit
                        hundreds <= 4'd0;
                        if (thousands!= 4'd9) begin
                            thousands <= thousands + 1;
                        end else begin
                            // Wrap around all digits
                            thousands <= 4'd0;
                        end
                    end
                end
            end
        end
    end

endmodule