module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_tens, ena_hundreds, ena_thousands;

    // Extracted outputs
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // On each clock edge, update the digits based on enable signals and reset
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;

            ena_tens <= 1'b0;
            ena_hundreds <= 1'b0;
            ena_thousands <= 1'b0;
        end else begin
            // Increment ones unconditionally
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_tens <= 1'b1;  // Enable tens digit increment next cycle
            end else begin
                ones <= ones + 4'd1;
                ena_tens <= 1'b0;
            end

            // Increment tens if enabled
            if (ena_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena_hundreds <= 1'b1; // Enable hundreds digit increment next cycle
                end else begin
                    tens <= tens + 4'd1;
                    ena_hundreds <= 1'b0;
                end
            end else begin
                ena_hundreds <= 1'b0;
            end

            // Increment hundreds if enabled
            if (ena_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena_thousands <= 1'b1; // Enable thousands digit increment next cycle
                end else begin
                    hundreds <= hundreds + 4'd1;
                    ena_thousands <= 1'b0;
                end
            end else begin
                ena_thousands <= 1'b0;
            end

            // Increment thousands if enabled
            if (ena_thousands) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

endmodule