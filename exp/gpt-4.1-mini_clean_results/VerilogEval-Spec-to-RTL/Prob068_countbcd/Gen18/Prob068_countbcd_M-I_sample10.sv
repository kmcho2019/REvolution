module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    // Registers for digits
    reg [3:0] d0, d1, d2, d3;

    // Wires for carry signals
    wire c0, c1, c2;

    // Next digit values
    wire [3:0] d0_next, d1_next, d2_next, d3_next;

    // Combinational carry and next value calculation (parallel)
    // Increment ones digit:
    assign {c0, d0_next} = (d0 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d0 + 1'b1};

    // Tens digit increments if carry from ones digit
    assign {c1, d1_next} = c0 ? ((d1 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d1 + 1'b1}) : {1'b0, d1};

    // Hundreds digit increments if carry from tens digit
    assign {c2, d2_next} = c1 ? ((d2 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d2 + 1'b1}) : {1'b0, d2};

    // Thousands digit increments if carry from hundreds digit
    assign d3_next = c2 ? ((d3 == 4'd9) ? 4'd0 : d3 + 1'b1) : d3;

    // Enable signals indicate when each upper digit increments (carry out)
    assign ena = {c2, c1, c0};

    // Clock enable signals to update registers only when value changes
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

    // Sequential logic with synchronous reset
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

    // Output concatenation
    assign q = {d3, d2, d1, d0};

endmodule