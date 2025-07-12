module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Define the internal signals
reg [3:0] q_ones;  // ones digit
reg [3:0] q_tens;  // tens digit
reg [3:0] q_hundreds;  // hundreds digit
reg [3:0] q_thousands;  // thousands digit

// Define the enable signals
reg ena_ones;  // always enabled
reg ena_tens;  // enable when ones digit is 9
reg ena_hundreds;  // enable when tens digit is 9
reg ena_thousands;  // enable when hundreds digit is 9

// Initialize the internal signals
initial begin
    q_ones = 4'd0;
    q_tens = 4'd0;
    q_hundreds = 4'd0;
    q_thousands = 4'd0;
end

// Define the logic for the ones digit
always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'd0;
    end else begin
        if (q_ones == 4'd9) begin
            q_ones <= 4'd0;
        end else begin
            q_ones <= q_ones + 1;
        end
    end
end

// Define the logic for the tens digit
always @(posedge clk) begin
    if (reset) begin
        q_tens <= 4'd0;
    end else if (q_ones == 4'd9) begin
        if (q_tens == 4'd9) begin
            q_tens <= 4'd0;
        end else begin
            q_tens <= q_tens + 1;
        end
    end else begin
        q_tens <= q_tens;
    end
end

// Define the logic for the hundreds digit
always @(posedge clk) begin
    if (reset) begin
        q_hundreds <= 4'd0;
    end else if (q_tens == 4'd9 && q_ones == 4'd0) begin
        if (q_hundreds == 4'd9) begin
            q_hundreds <= 4'd0;
        end else begin
            q_hundreds <= q_hundreds + 1;
        end
    end else begin
        q_hundreds <= q_hundreds;
    end
end

// Define the logic for the thousands digit
always @(posedge clk) begin
    if (reset) begin
        q_thousands <= 4'd0;
    end else if (q_hundreds == 4'd9 && q_tens == 4'd0 && q_ones == 4'd0) begin
        if (q_thousands == 4'd9) begin
            q_thousands <= 4'd0;
        end else begin
            q_thousands <= q_thousands + 1;
        end
    end else begin
        q_thousands <= q_thousands;
    end
end

// Assign the output signals
assign ena = {ena_thousands, ena_hundreds, ena_tens};
assign q = {q_thousands, q_hundreds, q_tens, q_ones};

// Assign the enable signals
assign ena_ones = 1'b1;  // always enabled
assign ena_tens = (q_ones == 4'd9)? 1'b1 : 1'b0;
assign ena_hundreds = (q_tens == 4'd9 && q_ones == 4'd0)? 1'b1 : 1'b0;
assign ena_thousands = (q_hundreds == 4'd9 && q_tens == 4'd0 && q_ones == 4'd0)? 1'b1 : 1'b0;

endmodule