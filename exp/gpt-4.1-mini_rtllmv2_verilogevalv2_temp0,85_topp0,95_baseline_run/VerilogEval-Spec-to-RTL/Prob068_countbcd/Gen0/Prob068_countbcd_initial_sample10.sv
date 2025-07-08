module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digits as separate 4-bit regs for clarity
    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
        end else begin
            ena <= 3'b000; // default no enable signals

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena[0] <= 1'b1; // enable tens increment
            end else begin
                ones <= ones + 1;
            end

            // Tens digit increment controlled by ena[0]
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena[1] <= 1'b1; // enable hundreds increment
                end else begin
                    tens <= tens + 1;
                end
            end

            // Hundreds digit increment controlled by ena[1]
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena[2] <= 1'b1; // enable thousands increment
                end else begin
                    hundreds <= hundreds + 1;
                end
            end

            // Thousands digit increment controlled by ena[2]
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 1;
                end
            end
        end
    end

    // Pack digits into q output
    always @(*) begin
        q = {thousands, hundreds, tens, ones};
    end

endmodule