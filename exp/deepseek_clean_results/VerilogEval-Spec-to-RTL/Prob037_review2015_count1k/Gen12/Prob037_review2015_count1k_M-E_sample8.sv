module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] units;

// Combine digits to form the 10-bit output
assign q = {hundreds, tens, units};

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'd0;
        tens <= 4'd0;
        units <= 4'd0;
    end else begin
        // Units digit counter
        if (units == 4'd9) begin
            units <= 4'd0;
            // Tens digit counter
            if (tens == 4'd9) begin
                tens <= 4'd0;
                // Hundreds digit counter
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end else
                tens <= tens + 1'b1;
        end else
            units <= units + 1'b1;
    end
end

// Additional logic to stop counting at 999
always @(posedge clk) begin
    if (!reset && hundreds == 4'd9 && tens == 4'd9 && units == 4'd9) begin
        hundreds <= 4'd0;
        tens <= 4'd0;
        units <= 4'd0;
    end
end

endmodule