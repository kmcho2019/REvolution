module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units, tens, hundreds;

// Units counter (0-9)
always @(posedge clk) begin
    if (reset) units <= 4'd0;
    else if (units == 4'd9) units <= 4'd0;
    else units <= units + 1'b1;
end

// Tens counter (0-9) - increments when units rolls over
always @(posedge clk) begin
    if (reset) tens <= 4'd0;
    else if (units == 4'd9) begin
        if (tens == 4'd9) tens <= 4'd0;
        else tens <= tens + 1'b1;
    end
end

// Hundreds counter (0-9) - increments when tens rolls over
always @(posedge clk) begin
    if (reset) hundreds <= 4'd0;
    else if (units == 4'd9 && tens == 4'd9) begin
        if (hundreds == 4'd9) hundreds <= 4'd0;
        else hundreds <= hundreds + 1'b1;
    end
end

// Combine digits to form final output
assign q = {hundreds, tens, units};

endmodule