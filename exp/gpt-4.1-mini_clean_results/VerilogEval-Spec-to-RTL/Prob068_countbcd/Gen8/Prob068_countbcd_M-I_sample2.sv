module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    reg [3:0] d0, d1, d2, d3;         // individual digits registers
    wire c0, c1, c2;                  // carry signals for increment enable

    // Determine carry c0 from ones digit rollover (d0 == 9)
    assign c0 = (d0 == 4'd9);
    // Determine carry c1 from tens digit rollover AND c0 enabled (tens increments only on ones rollover)
    assign c1 = c0 && (d1 == 4'd9);
    // Determine carry c2 from hundreds digit rollover AND c1 enabled
    assign c2 = c1 && (d2 == 4'd9);

    // ena signals indicate when digits 1 (tens), 2 (hundreds), and 3 (thousands) increment
    assign ena = {c2, c1, c0};

    // Compute next digit values with carry look-ahead:
    // increment ones digit by 1, wrap at 9
    wire [3:0] d0_next = c0 ? 4'd0 : d0 + 4'd1;
    // increment tens digit by 1 if c0, else hold
    wire [3:0] d1_next = c0 ? (c1 ? 4'd0 : d1 + 4'd1) : d1;
    // increment hundreds digit by 1 if c1, else hold
    wire [3:0] d2_next = c1 ? (c2 ? 4'd0 : d2 + 4'd1) : d2;
    // increment thousands digit by 1 if c2, else hold
    wire [3:0] d3_next = c2 ? (d3 == 4'd9 ? 4'd0 : d3 + 4'd1) : d3;

    // Clock enable for each digit: update only if value changes to reduce switching and save power
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

    // Sequential logic with clock gating (digit registers update only when enabled)
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

    // Output concatenation of digits
    assign q = {d3, d2, d1, d0};

endmodule