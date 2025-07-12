module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b0;
        end else begin
            // Start incrementing ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena[0] <= 1'b1; // enable tens digit increment
                // increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena[1] <= 1'b1; // enable hundreds digit increment
                    // increment hundreds digit
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        ena[2] <= 1'b1; // enable thousands digit increment
                        // increment thousands digit
                        if (thousands == 4'd9)
                            thousands <= 4'd0;
                        else
                            thousands <= thousands + 4'd1;
                    end else begin
                        hundreds <= hundreds + 4'd1;
                        ena[2] <= 1'b0;
                    end
                end else begin
                    tens <= tens + 4'd1;
                    ena[1] <= 1'b0;
                    ena[2] <= 1'b0;
                end
            end else begin
                ones <= ones + 4'd1;
                ena <= 3'b0;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule