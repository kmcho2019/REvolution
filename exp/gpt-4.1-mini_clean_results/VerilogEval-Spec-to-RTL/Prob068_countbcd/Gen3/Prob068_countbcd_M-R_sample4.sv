module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digit registers
    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            // Intermediate carry enables
            reg inc_tens, inc_hundreds, inc_thousands;

            // Increment ones digit and check carry
            if (ones == 4'd9) begin
                ones <= 4'd0;
                inc_tens = 1'b1; // carry to tens
            end else begin
                ones <= ones + 4'd1;
                inc_tens = 1'b0;
            end

            // Increment tens digit if carry from ones
            if (inc_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    inc_hundreds = 1'b1; // carry to hundreds
                end else begin
                    tens <= tens + 4'd1;
                    inc_hundreds = 1'b0;
                end
            end else begin
                inc_hundreds = 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (inc_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    inc_thousands = 1'b1; // carry to thousands
                end else begin
                    hundreds <= hundreds + 4'd1;
                    inc_thousands = 1'b0;
                end
            end else begin
                inc_thousands = 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (inc_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end

            // ena signals correspond to upper digit increments this cycle
            ena <= {inc_thousands, inc_hundreds, inc_tens};

            // Concatenate digits for output
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule