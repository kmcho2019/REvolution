module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] d0, d1, d2, d3;    // ones, tens, hundreds, thousands digits

    // Carry signals when digit == 9
    wire c0 = (d0 == 4'd9);      // carry from ones to tens
    wire c1 = c0 && (d1 == 4'd9); // carry from tens to hundreds
    wire c2 = c1 && (d2 == 4'd9); // carry from hundreds to thousands

    // ena indicates when each upper digit increments
    assign ena = {c2, c1, c0};

    // Next digit values with wrap-around at 9
    wire [3:0] d0_next = c0 ? 4'd0 : d0 + 4'd1;
    wire [3:0] d1_next = c0 ? (c1 ? 4'd0 : d1 + 4'd1) : d1;
    wire [3:0] d2_next = c1 ? (c2 ? 4'd0 : d2 + 4'd1) : d2;
    wire [3:0] d3_next = c2 ? (d3 == 4'd9 ? 4'd0 : d3 + 4'd1) : d3;

    // Clock-enable signals: update digits only if next != current (power saving)
    wire ce0 = (d0_next != d0);
    wire ce1 = (d1_next != d1);
    wire ce2 = (d2_next != d2);
    wire ce3 = (d3_next != d3);

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

    // Concatenate digits to form 16-bit output q
    assign q = {d3, d2, d1, d0};

endmodule