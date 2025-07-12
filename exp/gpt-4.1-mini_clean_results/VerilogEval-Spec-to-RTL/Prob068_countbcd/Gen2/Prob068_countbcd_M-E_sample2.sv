module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_tens, ena_hundreds, ena_thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;

            ena_tens     <= 1'b0;
            ena_hundreds <= 1'b0;
            ena_thousands<= 1'b0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_tens <= 1'b1;
            end else begin
                ones <= ones + 4'd1;
                ena_tens <= 1'b0;
            end

            // Increment tens digit if carry from ones
            if (ena_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena_hundreds <= 1'b1;
                end else begin
                    tens <= tens + 4'd1;
                    ena_hundreds <= 1'b0;
                end
            end else begin
                ena_hundreds <= 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (ena_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena_thousands <= 1'b1;
                end else begin
                    hundreds <= hundreds + 4'd1;
                    ena_thousands <= 1'b0;
                end
            end else begin
                ena_thousands <= 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (ena_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    always @(*) begin
        // Combine digits into 16-bit output
        q = {thousands, hundreds, tens, ones};
        ena = {ena_thousands, ena_hundreds, ena_tens};
    end

endmodule