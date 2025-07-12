module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units, tens, hundreds;
wire units_max = (units == 4'd9);
wire tens_max = (tens == 4'd9);
wire hundreds_max = (hundreds == 4'd9);

// Units counter
always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
    end else if (units_max) begin
        units <= 4'b0;
    end else begin
        units <= units + 1'b1;
    end
end

// Tens counter
always @(posedge clk) begin
    if (reset) begin
        tens <= 4'b0;
    end else if (units_max) begin
        if (tens_max) begin
            tens <= 4'b0;
        end else begin
            tens <= tens + 1'b1;
        end
    end
end

// Hundreds counter
always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'b0;
    end else if (units_max && tens_max) begin
        if (hundreds_max) begin
            hundreds <= 4'b0;
        end else begin
            hundreds <= hundreds + 1'b1;
        end
    end
end

// Output conversion to binary
assign q = hundreds * 100 + tens * 10 + units;

endmodule