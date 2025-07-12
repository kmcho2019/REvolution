module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signals for each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Combinational logic for enable signals
    assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0;
    assign ena[1] = (tens == 4'd9 && ena[0]) ? 1'b1 : 1'b0;
    assign ena[2] = (hundreds == 4'd9 && ena[1]) ? 1'b1 : 1'b0;

    // Sequential logic for the counter
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment the counter
            if (ena[0]) begin
                ones <= ones + 1;
                if (ones == 4'd0) begin
                    if (ena[1]) begin
                        tens <= tens + 1;
                        if (tens == 4'd0) begin
                            if (ena[2]) begin
                                hundreds <= hundreds + 1;
                                if (hundreds == 4'd0) begin
                                    thousands <= thousands + 1;
                                end else begin
                                    thousands <= thousands;
                                end
                            end else begin
                                hundreds <= hundreds;
                                thousands <= thousands;
                            end
                        end else begin
                            hundreds <= hundreds;
                            thousands <= thousands;
                        end
                    end else begin
                        tens <= tens;
                        hundreds <= hundreds;
                        thousands <= thousands;
                    end
                end else begin
                    tens <= tens;
                    hundreds <= hundreds;
                    thousands <= thousands;
                end
            end else begin
                ones <= ones;
                tens <= tens;
                hundreds <= hundreds;
                thousands <= thousands;
            end
        end
    end

    // Output assignments
    assign q[3:0] = ones;
    assign q[7:4] = tens;
    assign q[11:8] = hundreds;
    assign q[15:12] = thousands;

endmodule