module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] ones, tens, hundreds;
wire ones_overflow, tens_overflow;

// Ones digit counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0;
    end else if (ones == 4'd9) begin
        ones <= 4'b0;
    end else begin
        ones <= ones + 1'b1;
    end
end

assign ones_overflow = (ones == 4'd9);

// Tens digit counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        tens <= 4'b0;
    end else if (ones_overflow) begin
        if (tens == 4'd9) begin
            tens <= 4'b0;
        end else begin
            tens <= tens + 1'b1;
        end
    end
end

assign tens_overflow = (tens == 4'd9) & ones_overflow;

// Hundreds digit counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'b0;
    end else if (tens_overflow) begin
        if (hundreds == 4'd9) begin
            hundreds <= 4'b0;
        end else begin
            hundreds <= hundreds + 1'b1;
        end
    end
end

// Output reconstruction
assign q = {hundreds, tens, ones};

endmodule