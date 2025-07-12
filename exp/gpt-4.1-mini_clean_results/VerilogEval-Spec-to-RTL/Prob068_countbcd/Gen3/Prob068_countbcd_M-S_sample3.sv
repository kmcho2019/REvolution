module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits for convenience
    wire [3:0] ones     = q[3:0];
    wire [3:0] tens     = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands= q[15:12];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            reg [3:0] ones_n, tens_n, hundreds_n, thousands_n;
            reg ena_tens, ena_hundreds, ena_thousands;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones_n = 4'd0;
                ena_tens = 1'b1;  // tens will increment
            end else begin
                ones_n = ones + 1;
                ena_tens = 1'b0;
            end

            // Increment tens digit if needed
            if (ena_tens) begin
                if (tens == 4'd9) begin
                    tens_n = 4'd0;
                    ena_hundreds = 1'b1; // hundreds will increment
                end else begin
                    tens_n = tens + 1;
                    ena_hundreds = 1'b0;
                end
            end else begin
                tens_n = tens;
                ena_hundreds = 1'b0;
            end

            // Increment hundreds digit if needed
            if (ena_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds_n = 4'd0;
                    ena_thousands = 1'b1; // thousands will increment
                end else begin
                    hundreds_n = hundreds + 1;
                    ena_thousands = 1'b0;
                end
            end else begin
                hundreds_n = hundreds;
                ena_thousands = 1'b0;
            end

            // Increment thousands digit if needed
            if (ena_thousands) begin
                if (thousands == 4'd9) begin
                    thousands_n = 4'd0;
                end else begin
                    thousands_n = thousands + 1;
                end
            end else begin
                thousands_n = thousands;
            end

            // Update output register
            q <= {thousands_n, hundreds_n, tens_n, ones_n};

            // Assign ena outputs to indicate digit increments
            ena <= {ena_thousands, ena_hundreds, ena_tens};
        end
    end

endmodule