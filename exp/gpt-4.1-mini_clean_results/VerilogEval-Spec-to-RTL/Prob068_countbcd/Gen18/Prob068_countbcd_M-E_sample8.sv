module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] count;
    reg [15:0] next_count;

    wire [3:0] digit0, digit1, digit2, digit3;
    wire [3:0] sum0, sum1, sum2, sum3;
    wire c0, c1, c2;

    // Extract digits from current count
    assign digit0 = count[3:0];
    assign digit1 = count[7:4];
    assign digit2 = count[11:8];
    assign digit3 = count[15:12];

    // Binary + 1 addition for ones digit (no carry in)
    assign {c0, sum0} = digit0 + 4'd1;

    // Add carry from previous digit for tens digit, then correct
    assign {c1, sum1} = digit1 + c0;

    // Add carry from previous digit for hundreds digit, then correct
    assign {c2, sum2} = digit2 + c1;

    // Add carry from previous digit for thousands digit
    // thousands digit max 9, so c2 can be 1 max
    assign sum3 = digit3 + c2;

    // Function to correct a digit if >9 by adding 6
    function [3:0] bcd_correction(input [4:0] val);
        begin
            if (val > 9)
                bcd_correction = val + 4'd6;
            else
                bcd_correction = val[3:0];
        end
    endfunction

    // Correct digits if needed after addition
    wire [4:0] raw0 = digit0 + 5'd1;
    wire [4:0] raw1 = digit1 + c0;
    wire [4:0] raw2 = digit2 + c1;
    wire [4:0] raw3 = digit3 + c2;

    wire [3:0] corr0 = bcd_correction(raw0);
    wire [3:0] corr1 = bcd_correction(raw1);
    wire [3:0] corr2 = bcd_correction(raw2);
    wire [3:0] corr3 = bcd_correction(raw3);

    assign next_count = {corr3, corr2, corr1, corr0};

    // Generate enable signals indicating when upper digits should increment
    // ena[0] for tens digit increment: when ones digit wraps from 9 to 0 (digit0 == 9)
    // ena[1] for hundreds digit increment: when tens digit wraps (digit1 == 9) and ones digit just wrapped
    // ena[2] for thousands digit increment: when hundreds digit wraps (digit2 == 9) and tens and ones digits just wrapped
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = ena[0] && (digit1 == 4'd9);
    assign ena[2] = ena[1] && (digit2 == 4'd9);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count;
    end

    assign q = count;

endmodule