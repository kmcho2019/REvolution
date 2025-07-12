module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    // 4-bit BCD digit registers: ones (d0), tens (d1), hundreds (d2), thousands (d3)
    reg [3:0] d0, d1, d2, d3;

    // Carry signals for increment chaining
    wire c0, c1, c2;

    // Next digit values computed combinationally in parallel
    wire [3:0] d0_next, d1_next, d2_next, d3_next;

    // Increment ones digit, carry out if digit wraps from 9 to 0
    assign {c0, d0_next} = (d0 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d0 + 1'b1};

    // Increment tens digit if ones digit rolled over
    assign {c1, d1_next} = c0 ? ((d1 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d1 + 1'b1}) : {1'b0, d1};

    // Increment hundreds digit if tens digit rolled over
    assign {c2, d2_next} = c1 ? ((d2 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d2 + 1'b1}) : {1'b0, d2};

    // Increment thousands digit if hundreds digit rolled over
    assign d3_next = c2 ? ((d3 == 4'd9) ? 4'd0 : d3 + 1'b1) : d3;

    // ena signals indicate when each upper digit should increment (carry out from previous digit)
    assign ena = {c2, c1, c0};

    // Clock enable signals to update registers only when values change (for power saving)
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

    // Synchronous reset and register update on positive clock edge
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

    // Concatenate digits for 16-bit BCD output, thousands on MSB side
    assign q = {d3, d2, d1, d0};

endmodule