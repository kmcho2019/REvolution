module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Separate 4-bit counters for each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    // Registered enable signals
    reg ena_tens;
    reg ena_hundreds;
    reg ena_thousands;
    
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {ena_thousands, ena_hundreds, ena_tens};
    
    // Ones digit counter (always increments)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 1;
        end
    end
    
    // Tens digit counter (enabled by ones overflow)
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (ena_tens) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 1;
        end
    end
    
    // Hundreds digit counter (enabled by tens overflow)
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (ena_hundreds) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 1;
        end
    end
    
    // Thousands digit counter (enabled by hundreds overflow)
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena_thousands) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
        end
    end
    
    // Enable generation (registered for better timing)
    always @(posedge clk) begin
        if (reset) begin
            ena_tens <= 1'b0;
            ena_hundreds <= 1'b0;
            ena_thousands <= 1'b0;
        end else begin
            ena_tens <= (ones == 4'd9);
            ena_hundreds <= (ena_tens && (tens == 4'd9));
            ena_thousands <= (ena_hundreds && (hundreds == 4'd9));
        end
    end

endmodule