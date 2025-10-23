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
            // Increment ones digit unconditionally each clock
            if (ones == 4'd9) begin
                ones <= 4'd0;
                // ones carried out, increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // tens carried out, increment hundreds digit
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        // hundreds carried out, increment thousands digit
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                            ena <= 3'b111; // all digits incremented (upper three digits)
                        end else begin
                            thousands <= thousands + 4'd1;
                            ena <= 3'b110; // thousands and lower digits incremented
                        end
                    end else begin
                        hundreds <= hundreds + 4'd1;
                        ena <= 3'b100; // hundreds and lower digits incremented
                    end
                end else begin
                    tens <= tens + 4'd1;
                    ena <= 3'b010; // tens and ones incremented
                end
            end else begin
                ones <= ones + 4'd1;
                ena <= 3'b001; // only ones incremented
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule