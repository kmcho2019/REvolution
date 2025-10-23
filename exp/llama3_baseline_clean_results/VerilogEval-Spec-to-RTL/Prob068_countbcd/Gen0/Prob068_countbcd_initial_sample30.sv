module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // internal signal to track the 4 BCD digits
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // internal signal to track the enable signals
    reg ena_ones;
    reg ena_tens;
    reg ena_hundreds;

    always @(posedge clk) begin
        // synchronous reset
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_ones <= 1'b1;
            end else begin
                ones <= ones + 4'd1;
                ena_ones <= 1'b0;
            end

            // increment tens digit
            if (ena_ones) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena_tens <= 1'b1;
                end else begin
                    tens <= tens + 4'd1;
                    ena_tens <= 1'b0;
                end
            end else begin
                ena_tens <= 1'b0;
            end

            // increment hundreds digit
            if (ena_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena_hundreds <= 1'b1;
                end else begin
                    hundreds <= hundreds + 4'd1;
                    ena_hundreds <= 1'b0;
                end
            end else begin
                ena_hundreds <= 1'b0;
            end

            // increment thousands digit
            if (ena_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    // assign output signals
    assign q[3:0] = ones;
    assign q[7:4] = tens;
    assign q[11:8] = hundreds;
    assign q[15:12] = thousands;
    assign ena[0] = ena_ones;
    assign ena[1] = ena_tens;
    assign ena[2] = ena_hundreds;

endmodule