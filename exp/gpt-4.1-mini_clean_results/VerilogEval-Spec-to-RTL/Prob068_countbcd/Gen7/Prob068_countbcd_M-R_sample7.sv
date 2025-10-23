module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_ones, ena_tens, ena_hundreds;

    // Increment ones digit every clock
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            ena_ones <= 1'b0;
        end else begin
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_ones <= 1'b1;  // Enable tens to increment next cycle
            end else begin
                ones <= ones + 1'b1;
                ena_ones <= 1'b0;
            end
        end
    end

    // Increment tens digit when ena_ones asserted
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
            ena_tens <= 1'b0;
        end else if (ena_ones) begin
            if (tens == 4'd9) begin
                tens <= 4'd0;
                ena_tens <= 1'b1;  // Enable hundreds increment next cycle
            end else begin
                tens <= tens + 1'b1;
                ena_tens <= 1'b0;
            end
        end else begin
            ena_tens <= 1'b0;  // Clear enable if not triggered
        end
    end

    // Increment hundreds digit when ena_tens asserted
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
            ena_hundreds <= 1'b0;
        end else if (ena_tens) begin
            if (hundreds == 4'd9) begin
                hundreds <= 4'd0;
                ena_hundreds <= 1'b1;  // Enable thousands increment next cycle
            end else begin
                hundreds <= hundreds + 1'b1;
                ena_hundreds <= 1'b0;
            end
        end else begin
            ena_hundreds <= 1'b0; // Clear enable if not triggered
        end
    end

    // Increment thousands digit when ena_hundreds asserted
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena_hundreds) begin
            if (thousands == 4'd9) begin
                thousands <= 4'd0; // rollover after 9999 to 0000
            end else begin
                thousands <= thousands + 1'b1;
            end
        end
    end

    // Outputs
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {ena_hundreds, ena_tens, ena_ones};

endmodule