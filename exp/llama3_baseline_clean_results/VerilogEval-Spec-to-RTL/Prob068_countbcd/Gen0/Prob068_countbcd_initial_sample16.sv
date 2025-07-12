module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signal declarations
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Initialize enable signals
    assign ena[0] = (ones == 9)? 1'b1 : 1'b0;
    assign ena[1] = (tens == 9 && ena[0] == 1'b1)? 1'b1 : 1'b0;
    assign ena[2] = (hundreds == 9 && ena[1] == 1'b1 && ena[0] == 1'b1)? 1'b1 : 1'b0;

    // Synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thousands <= 0;
        end else begin
            if (ones == 9) begin
                ones <= 0;
                if (tens == 9) begin
                    tens <= 0;
                    if (hundreds == 9) begin
                        hundreds <= 0;
                        if (thousands == 9) begin
                            thousands <= 0;
                        end else begin
                            thousands <= thousands + 1;
                        end
                    end else if (ena[1] == 1'b1) begin
                        hundreds <= hundreds + 1;
                    end
                end else if (ena[0] == 1'b1) begin
                    tens <= tens + 1;
                end
            end else begin
                ones <= ones + 1;
            end
        end
    end

    // Assign output signal
    assign q = {thousands, hundreds, tens, ones};

endmodule