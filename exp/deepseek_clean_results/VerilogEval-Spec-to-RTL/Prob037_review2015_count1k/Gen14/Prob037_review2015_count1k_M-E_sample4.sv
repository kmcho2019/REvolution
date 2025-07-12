module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units;    // 0-9
reg [3:0] tens;     // 0-9
reg [3:0] hundreds; // 0-9

// Units digit counter
always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
    end else begin
        if (units == 4'd9) begin
            units <= 4'b0;
        end else begin
            units <= units + 1'b1;
        end
    end
end

// Tens digit counter (increments when units rolls over)
always @(posedge clk) begin
    if (reset) begin
        tens <= 4'b0;
    end else if (units == 4'd9) begin
        if (tens == 4'd9) begin
            tens <= 4'b0;
        end else begin
            tens <= tens + 1'b1;
        end
    end
end

// Hundreds digit counter (increments when tens rolls over)
always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'b0;
    end else if (units == 4'd9 && tens == 4'd9) begin
        if (hundreds == 4'd9) begin
            hundreds <= 4'b0;
        end else begin
            hundreds <= hundreds + 1'b1;
        end
    end
end

// Combine digits to form 10-bit output
assign q = {hundreds, tens, units};

endmodule