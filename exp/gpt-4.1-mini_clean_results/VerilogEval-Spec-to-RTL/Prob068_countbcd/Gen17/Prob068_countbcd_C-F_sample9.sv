module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    // Separate 4-bit registers for each BCD digit
    reg [3:0] d0, d1, d2, d3;

    // Function: Increment a BCD digit with carry out
    // Returns {carry_out, next_digit}
    function [4:0] bcd_inc;
        input [3:0] digit_in;
        begin
            if (digit_in == 4'd9)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit_in + 1'b1};
        end
    endfunction

    // Compute increment results starting from least significant digit
    wire [4:0] inc0 = bcd_inc(d0);
    wire [4:0] inc1 = c0 ? bcd_inc(d1) : {1'b0, d1};
    wire [4:0] inc2 = c1 ? bcd_inc(d2) : {1'b0, d2};
    wire [4:0] inc3 = c2 ? bcd_inc(d3) : {1'b0, d3};

    // Carry signals for digits
    wire c0 = inc0[4];
    wire c1 = inc1[4];
    wire c2 = inc2[4];

    // Next digit values based on carry propagation
    wire [3:0] d0_next = inc0[3:0];
    wire [3:0] d1_next = inc1[3:0];
    wire [3:0] d2_next = inc2[3:0];
    wire [3:0] d3_next = inc3[3:0];

    // Enable signals indicate when tens, hundreds, and thousands digits increment
    assign ena = {c2, c1, c0};

    // Clock enable signals - update digit only if value changes, reducing switching power
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            if (ce0) d0 <= d0_next;
            if (ce1) d1 <= d1_next;
            if (ce2) d2 <= d2_next;
            if (ce3) d3 <= d3_next;
        end
    end

    // Concatenate digits for 16-bit BCD output
    assign q = {d3, d2, d1, d0};

endmodule