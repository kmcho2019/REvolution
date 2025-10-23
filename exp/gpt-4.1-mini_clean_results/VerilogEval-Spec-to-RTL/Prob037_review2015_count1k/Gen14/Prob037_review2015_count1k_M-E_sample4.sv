module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] hundreds; // 0-9
    reg [3:0] units;    // 0-9

    // Next state logic combinational signals
    wire units_max = (units == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);

    wire units_next_reset = units_max;
    wire hundreds_next_reset = (units_max & hundreds_max);

    reg [3:0] units_next;
    reg [3:0] hundreds_next;

    always @(*) begin
        // Units digit logic
        if (units_next_reset)
            units_next = 4'd0;
        else
            units_next = units + 4'd1;

        // Hundreds digit logic
        if (hundreds_next_reset)
            hundreds_next = 4'd0;
        else if (units_next_reset)
            hundreds_next = hundreds + 4'd1;
        else
            hundreds_next = hundreds;
    end

    // Register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
            units <= 4'd0;
        end else begin
            hundreds <= hundreds_next;
            units <= units_next;
        end
    end

    // Combine digits to produce output q = hundreds * 10 + units
    // 10 * hundreds = hundreds * (8 + 2) = (hundreds << 3) + (hundreds << 1)
    always @(*) begin
        q = ( {hundreds,3'b000} /* hundreds<<3 */ ) + ( {hundreds,1'b0} /* hundreds<<1 */ ) + units;
    end

endmodule