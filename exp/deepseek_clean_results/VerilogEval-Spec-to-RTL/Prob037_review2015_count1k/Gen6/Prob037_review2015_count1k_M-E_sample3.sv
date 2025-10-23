module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] ones, tens, hundreds;
wire ones_rollover = (ones == 4'd9);
wire tens_rollover = (tens == 4'd9);

// Ones digit counter
always @(posedge clk) begin
    if (reset)
        ones <= 4'd0;
    else if (ones_rollover)
        ones <= 4'd0;
    else
        ones <= ones + 1'b1;
end

// Tens digit counter
always @(posedge clk) begin
    if (reset)
        tens <= 4'd0;
    else if (ones_rollover) begin
        if (tens_rollover)
            tens <= 4'd0;
        else
            tens <= tens + 1'b1;
    end
end

// Hundreds digit counter
always @(posedge clk) begin
    if (reset)
        hundreds <= 4'd0;
    else if (ones_rollover && tens_rollover) begin
        if (hundreds == 4'd9)
            hundreds <= 4'd0;
        else
            hundreds <= hundreds + 1'b1;
    end
end

// Output reconstruction
assign q = {hundreds, tens, ones} + 6'd0;  // Zero-extend to 10 bits

endmodule