module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] count;

    wire [3:0] ones      = count[3:0];
    wire [3:0] tens      = count[7:4];
    wire [3:0] hundreds  = count[11:8];
    wire [3:0] thousands = count[15:12];

    // Compute carry signals indicating if each digit will roll over from 9 to 0
    wire c0 = (ones == 4'd9);       // carry from ones to tens
    wire c1 = c0 && (tens == 4'd9);// carry from tens to hundreds
    wire c2 = c1 && (hundreds == 4'd9); // carry from hundreds to thousands

    // Enable signals: next digit increments when lower digit reaches 9
    assign ena[0] = c0;
    assign ena[1] = c1;
    assign ena[2] = c2;

    // Next digit values after increment considering carry-in
    wire [3:0] next_ones      = (ones != 4'd9)       ? (ones + 4'd1)       : 4'd0;
    wire [3:0] next_tens      = (c0) ? ((tens != 4'd9)       ? (tens + 4'd1)       : 4'd0) : tens;
    wire [3:0] next_hundreds  = (c1) ? ((hundreds != 4'd9)   ? (hundreds + 4'd1)   : 4'd0) : hundreds;
    wire [3:0] next_thousands = (c2) ? ((thousands != 4'd9)  ? (thousands + 4'd1)  : 4'd0) : thousands;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

    assign q = count;

endmodule