module TopModule (
    input         clk,
    input         reset,
    output reg [2:0]  ena,
    output reg [15:0] q
);

    // Wires to hold each BCD digit extracted from q
    wire [3:0] digit0, digit1, digit2, digit3;
    assign digit0 = q[3:0];
    assign digit1 = q[7:4];
    assign digit2 = q[11:8];
    assign digit3 = q[15:12];

    // Internal wires for the incremented digits and carry signals
    wire [3:0] inc_d0, inc_d1, inc_d2, inc_d3;
    wire c0, c1, c2;

    // Function to perform BCD digit increment with carry out
    function [4:0] bcd_inc; // 4-bit output + carry bit
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0}; // carry out, digit reset to 0
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Increment ones digit
    assign {c0, inc_d0} = bcd_inc(digit0);

    // Increment tens digit if carry from ones
    wire [4:0] tens_inc;
    assign tens_inc = c0 ? bcd_inc(digit1) : {1'b0, digit1};
    assign c1 = tens_inc[4];
    assign inc_d1 = tens_inc[3:0];

    // Increment hundreds digit if carry from tens
    wire [4:0] hundreds_inc;
    assign hundreds_inc = c1 ? bcd_inc(digit2) : {1'b0, digit2};
    assign c2 = hundreds_inc[4];
    assign inc_d2 = hundreds_inc[3:0];

    // Increment thousands digit if carry from hundreds
    wire [4:0] thousands_inc;
    assign thousands_inc = c2 ? bcd_inc(digit3) : {1'b0, digit3};
    assign inc_d3 = thousands_inc[3:0];

    // Enable signals: ena[0] for tens enable, ena[1] for hundreds enable, ena[2] for thousands enable
    // Enable signals indicate when lower digit has reached 9 (i.e., carry generated)
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b0;
        end else begin
            q <= {inc_d3, inc_d2, inc_d1, inc_d0};
            ena <= {c2, c1, c0}; // ena[2]=thousands enable, ena[1]=hundreds, ena[0]=tens
        end
    end

endmodule