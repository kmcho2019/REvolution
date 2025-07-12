module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_0, ena_1, ena_2;

    // Wires for next digit values and carry enables
    wire carry_0, carry_1, carry_2;
    wire [3:0] next_ones, next_tens, next_hundreds, next_thousands;

    // Increment ones digit
    assign carry_0 = (ones == 4'd9);
    assign next_ones = carry_0 ? 4'd0 : (ones + 4'd1);

    // Increment tens digit if ones digit rolled over
    assign carry_1 = (tens == 4'd9) & carry_0;
    assign next_tens = carry_0 ? (carry_1 ? 4'd0 : tens + 4'd1) : tens;

    // Increment hundreds digit if tens digit rolled over
    assign carry_2 = (hundreds == 4'd9) & carry_1;
    assign next_hundreds = carry_1 ? (carry_2 ? 4'd0 : hundreds + 4'd1) : hundreds;

    // Increment thousands digit if hundreds digit rolled over
    wire carry_3 = (thousands == 4'd9) & carry_2;
    assign next_thousands = carry_2 ? (carry_3 ? 4'd0 : thousands + 4'd1) : thousands;

    // ena signals correspond to enable of digits 1,2,3: tens, hundreds, thousands
    // Enable when previous digit rolls over
    wire ena_0_next = carry_0; // enable tens digit increment
    wire ena_1_next = carry_1; // enable hundreds digit increment
    wire ena_2_next = carry_2; // enable thousands digit increment

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena_0     <= 1'b0;
            ena_1     <= 1'b0;
            ena_2     <= 1'b0;
        end else begin
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;
            ena_0     <= ena_0_next;
            ena_1     <= ena_1_next;
            ena_2     <= ena_2_next;
        end
    end

    always @(*) begin
        q = {thousands, hundreds, tens, ones};
        ena = {ena_2, ena_1, ena_0};
    end

endmodule