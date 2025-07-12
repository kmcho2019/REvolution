module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Function to increment a BCD digit with carry out
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0};  // carry out, digit resets to 0
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Compute increments and carry outs combinationally
    wire [4:0] inc_ones      = bcd_inc(ones);
    wire [4:0] inc_tens      = (inc_ones[4])      ? bcd_inc(tens)      : {1'b0, tens};
    wire [4:0] inc_hundreds  = (inc_tens[4])      ? bcd_inc(hundreds)  : {1'b0, hundreds};
    wire [4:0] inc_thousands = (inc_hundreds[4])  ? bcd_inc(thousands) : {1'b0, thousands};

    // Enable signals: show when next digit should increment (when current digit == 9)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Update digits conditionally to reduce toggling (power efficient)
    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Update ones always
            bcd_count[3:0] <= inc_ones[3:0];
            // Update tens only if ones rolled over
            if (inc_ones[4])
                bcd_count[7:4] <= inc_tens[3:0];
            // Update hundreds only if tens rolled over
            if (inc_tens[4])
                bcd_count[11:8] <= inc_hundreds[3:0];
            // Update thousands only if hundreds rolled over
            if (inc_hundreds[4])
                bcd_count[15:12] <= inc_thousands[3:0];
        end
    end

    // Output full BCD count
    assign q = bcd_count;

endmodule