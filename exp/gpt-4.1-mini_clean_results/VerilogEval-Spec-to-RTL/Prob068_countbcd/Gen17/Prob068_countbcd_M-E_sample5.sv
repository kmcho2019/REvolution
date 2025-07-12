module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] q_reg;
    wire [15:0] q_next;

    // Function to increment a 4-digit BCD number by 1
    function [15:0] bcd_increment;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3;
        reg c0, c1, c2;
        begin
            d0 = val[3:0] + 4'd1;  // increment ones digit
            if (d0 > 9) begin
                d0 = 0;
                c0 = 1;
            end else
                c0 = 0;

            d1 = val[7:4] + c0;    // increment tens digit if carry from ones
            if (d1 > 9) begin
                d1 = 0;
                c1 = 1;
            end else
                c1 = 0;

            d2 = val[11:8] + c1;   // increment hundreds digit if carry from tens
            if (d2 > 9) begin
                d2 = 0;
                c2 = 1;
            end else
                c2 = 0;

            d3 = val[15:12] + c2;  // increment thousands digit if carry from hundreds
            if (d3 > 9)
                d3 = 0;             // roll over after 9999
            bcd_increment = {d3, d2, d1, d0};
        end
    endfunction

    // Update q_reg on clock edge, synchronous reset
    always @(posedge clk) begin
        if (reset)
            q_reg <= 16'd0;
        else
            q_reg <= bcd_increment(q_reg);
    end

    assign q = q_reg;

    // Generate enables based on current q_reg digits before increment:
    // ena[0]: increment tens digit when ones digit is 9 (carry out)
    // ena[1]: increment hundreds digit when ones and tens digits are 9
    // ena[2]: increment thousands digit when ones, tens, and hundreds digits are 9
    wire [3:0] ones      = q_reg[3:0];
    wire [3:0] tens      = q_reg[7:4];
    wire [3:0] hundreds  = q_reg[11:8];

    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

endmodule