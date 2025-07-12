module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
        ena <= 3'b000;
    end else begin
        // default values for enable signals
        ena <= 3'b000;

        if (ones == 4'b1001) begin
            // ones digit has reached 9, reset to 0 and increment tens
            ones <= 4'b0000;
            if (tens == 4'b1001) begin
                // tens digit has reached 9, reset to 0 and increment hundreds
                tens <= 4'b0000;
                if (hundreds == 4'b1001) begin
                    // hundreds digit has reached 9, reset to 0 and increment thousands
                    hundreds <= 4'b0000;
                    if (thousands == 4'b1001) begin
                        // thousands digit has reached 9, wrap around to 0
                        thousands <= 4'b0000;
                    end else begin
                        // increment thousands
                        thousands <= thousands + 1;
                        ena[2] <= 1'b1; // enable thousands
                    end
                end else begin
                    // increment hundreds
                    hundreds <= hundreds + 1;
                    ena[1] <= 1'b1; // enable hundreds
                end
            end else begin
                // increment tens
                tens <= tens + 1;
                ena[0] <= 1'b1; // enable tens
            end
        end else begin
            // increment ones
            ones <= ones + 1;
        end
    end

    // assign register values to output
    q[3:0] <= ones;
    q[7:4] <= tens;
    q[11:8] <= hundreds;
    q[15:12] <= thousands;
end

endmodule