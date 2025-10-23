module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_ones, ena_tens, ena_hundreds; // internal enables before registering to output ena

    // Detect rollover for each digit
    wire ones_rollover     = (ones == 4'd9);
    wire tens_rollover     = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    wire thousands_rollover= (thousands == 4'd9);

    // Increment logic for each digit using enable signals
    wire ones_en = 1'b1; // ones digit always increments
    wire tens_en = ena[0];       // tens enabled when ones rolled over last cycle
    wire hundreds_en = ena[1];   // hundreds enabled when tens rolled over last cycle
    wire thousands_en = ena[2];  // thousands enabled when hundreds rolled over last cycle

    // Next digit values
    wire [3:0] next_ones      = (ones == 4'd9) ? 4'd0 : ones + 1'b1;
    wire [3:0] next_tens      = (tens_en && tens_rollover) ? 4'd0 :
                               (tens_en) ? tens + 1'b1 : tens;
    wire [3:0] next_hundreds  = (hundreds_en && hundreds_rollover) ? 4'd0 :
                               (hundreds_en) ? hundreds + 1'b1 : hundreds;
    wire [3:0] next_thousands = (thousands_en && thousands_rollover) ? 4'd0 :
                               (thousands_en) ? thousands + 1'b1 : thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
        end else begin
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;

            // Update ena based on previous digit rollovers synchronously
            // ena[0] - enable tens if ones just rolled over
            ena[0] <= ones_rollover;
            // ena[1] - enable hundreds if tens just rolled over
            ena[1] <= tens_rollover && ena[0];
            // ena[2] - enable thousands if hundreds just rolled over
            ena[2] <= hundreds_rollover && ena[1];
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule