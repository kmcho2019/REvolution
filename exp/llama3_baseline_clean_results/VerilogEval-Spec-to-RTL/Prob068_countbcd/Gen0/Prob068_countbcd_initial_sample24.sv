module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// Internal wires for the BCD counters
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// Assign the internal wires to the output port q
assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

// Enable signals for the upper digits
assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0; // Enable tens when ones reaches 9
assign ena[1] = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0; // Enable hundreds when tens and ones reach 9
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0; // Enable thousands when hundreds, tens, and ones reach 9

// Sequential logic for the BCD counters
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset: Reset all counters to 0
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        // Increment the ones place
        if (ones == 4'd9) begin
            ones <= 4'd0;
            // Increment the tens place if ones wraps around
            if (tens == 4'd9) begin
                tens <= 4'd0;
                // Increment the hundreds place if tens wraps around
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    // Increment the thousands place if hundreds wraps around
                    if (thousands == 4'd9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 1'd1;
                    end
                end else if (ena[1]) begin
                    hundreds <= hundreds + 1'd1;
                end
            end else if (ena[0]) begin
                tens <= tens + 1'd1;
            end
        end else begin
            ones <= ones + 1'd1;
        end
    end
end

endmodule