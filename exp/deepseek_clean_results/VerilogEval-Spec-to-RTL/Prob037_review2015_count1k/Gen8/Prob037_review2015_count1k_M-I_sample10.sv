module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] ones, tens, hundreds;
wire ones_full = (ones == 4'd9);
wire tens_full = (tens == 4'd9);
wire hundreds_inc = (hundreds == 4'd9) && tens_full && ones_full;

wire ones_clken = ~reset;
wire tens_clken = (ones_full || reset);
wire hundreds_clken = (tens_full && ones_full) || reset;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0;
    end else if (ones_clken) begin
        ones <= ones_full ? 4'b0 : ones + 1'b1;
    end

    if (reset) begin
        tens <= 4'b0;
    end else if (tens_clken) begin
        tens <= ones_full ? (tens_full ? 4'b0 : tens + 1'b1) : tens;
    end

    if (reset) begin
        hundreds <= 4'b0;
    end else if (hundreds_clken) begin
        hundreds <= (ones_full && tens_full) ? 
                  (hundreds_inc ? 4'b0 : hundreds + 1'b1) : hundreds;
    end
end

assign q = {hundreds, tens, ones};

endmodule