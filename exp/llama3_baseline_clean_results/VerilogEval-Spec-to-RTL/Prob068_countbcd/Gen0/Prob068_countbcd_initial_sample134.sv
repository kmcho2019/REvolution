module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signals for the current value of each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Combinational logic to generate the enable signals
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && (ones == 4'd0);
    assign ena[2] = (hundreds == 4'd9) && (tens == 4'd0) && (ones == 4'd0);

    // Sequential logic to update the counter values
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to zero
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment the ones place
            if (ones == 4'd9) begin
                ones <= 4'd0;
                // Increment the tens place if necessary
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Increment the hundreds place if necessary
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        // Increment the thousands place if necessary
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                        end else begin
                            thousands <= thousands + 1;
                        end
                    end else begin
                        hundreds <= hundreds + 1;
                    end
                end else begin
                    tens <= tens + 1;
                end
            end else begin
                ones <= ones + 1;
            end
        end
    end

    // Assign the internal signals to the output ports
    assign q[3:0] = ones;
    assign q[7:4] = tens;
    assign q[11:8] = hundreds;
    assign q[15:12] = thousands;

endmodule