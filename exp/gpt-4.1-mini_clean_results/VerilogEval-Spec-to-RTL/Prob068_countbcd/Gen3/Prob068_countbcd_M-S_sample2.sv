module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [15:0] count; // Four BCD digits: [15:12] thousands, [11:8] hundreds, [7:4] tens, [3:0] ones

    wire carry_ones;
    wire carry_tens;
    wire carry_hundreds;

    wire [3:0] ones_next;
    wire [3:0] tens_next;
    wire [3:0] hundreds_next;
    wire [3:0] thousands_next;

    // Extract digits
    wire [3:0] ones     = count[3:0];
    wire [3:0] tens     = count[7:4];
    wire [3:0] hundreds = count[11:8];
    wire [3:0] thousands= count[15:12];

    // Increment ones digit
    assign carry_ones = (ones == 4'd9);
    assign ones_next = carry_ones ? 4'd0 : ones + 4'd1;

    // Increment tens digit if carry from ones
    assign carry_tens = (tens == 4'd9) && carry_ones;
    assign tens_next = carry_ones ? (carry_tens ? 4'd0 : tens + 4'd1) : tens;

    // Increment hundreds digit if carry from tens
    assign carry_hundreds = (hundreds == 4'd9) && carry_tens;
    assign hundreds_next = carry_tens ? (carry_hundreds ? 4'd0 : hundreds + 4'd1) : hundreds;

    // Increment thousands digit if carry from hundreds
    assign thousands_next = carry_hundreds ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
            ena <= 3'b000;
        end else begin
            count <= {thousands_next, hundreds_next, tens_next, ones_next};
            ena <= {carry_hundreds, carry_tens, carry_ones};
        end
    end

    always @(*) begin
        q = count;
    end

endmodule