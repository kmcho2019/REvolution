module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires to indicate when each digit reaches 9 (to enable next digit)
    wire ena1, ena2, ena3;
    wire [3:0] ones, tens, hundreds, thousands;
    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;

    assign ones      = q[3:0];
    assign tens      = q[7:4];
    assign hundreds  = q[11:8];
    assign thousands = q[15:12];

    always @(*) begin
        // Default no increment to next digit enable signals
        ena1 = 0;
        ena2 = 0;
        ena3 = 0;

        // Next values default to current values
        ones_next      = ones;
        tens_next      = tens;
        hundreds_next  = hundreds;
        thousands_next = thousands;

        // Increment ones digit each clock cycle
        if (ones == 4'd9) begin
            ones_next = 4'd0;
            ena1 = 1'b1;
        end else begin
            ones_next = ones + 1'b1;
        end

        // Increment tens digit if ena1 asserted
        if (ena1) begin
            if (tens == 4'd9) begin
                tens_next = 4'd0;
                ena2 = 1'b1;
            end else begin
                tens_next = tens + 1'b1;
            end
        end

        // Increment hundreds digit if ena2 asserted
        if (ena2) begin
            if (hundreds == 4'd9) begin
                hundreds_next = 4'd0;
                ena3 = 1'b1;
            end else begin
                hundreds_next = hundreds + 1'b1;
            end
        end

        // Increment thousands digit if ena3 asserted
        if (ena3) begin
            if (thousands == 4'd9) begin
                thousands_next = 4'd0;
            end else begin
                thousands_next = thousands + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            q[3:0]   <= ones_next;
            q[7:4]   <= tens_next;
            q[11:8]  <= hundreds_next;
            q[15:12] <= thousands_next;
            ena <= {ena3, ena2, ena1};
        end
    end

endmodule