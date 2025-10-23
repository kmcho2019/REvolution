module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    // Registers for individual BCD digits
    reg [3:0] d0, d1, d2, d3;

    // Function: Increment BCD digit with carry out
    // Returns {carry_out, next_digit_value}
    function [4:0] bcd_inc;
        input [3:0] digit_in;
    begin
        if (digit_in == 4'd9)
            bcd_inc = {1'b1, 4'd0};
        else
            bcd_inc = {1'b0, digit_in + 1'b1};
    end
    endfunction

    // Compute next digit values and carry signals
    wire [4:0] inc0 = bcd_inc(d0);
    wire [4:0] inc1 = bcd_inc(d1);
    wire [4:0] inc2 = bcd_inc(d2);
    wire [4:0] inc3 = bcd_inc(d3);

    // Carry chain logic: propagate carry as needed
    wire c0 = inc0[4];              // carry from ones digit
    wire c1 = c0 ? inc1[4] : 1'b0; // carry from tens digit if c0
    wire c2 = c1 ? inc2[4] : 1'b0; // carry from hundreds digit if c1

    // Enable signals: indicate when tens, hundreds, thousands increment
    assign ena = {c2, c1, c0};

    // Compute next values for each digit considering carry-in
    wire [3:0] d0_next = inc0[3:0];
    wire [3:0] d1_next = c0 ? inc1[3:0] : d1;
    wire [3:0] d2_next = c1 ? inc2[3:0] : d2;
    wire [3:0] d3_next = c2 ? inc3[3:0] : d3;

    // Clock-enable signals: update register only if value changes (power saving)
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

    // Sequential logic: update digits on rising clock edge with synchronous reset
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

    // Output concatenation: thousands, hundreds, tens, ones
    assign q = {d3, d2, d1, d0};

endmodule