// Top-level module freq_div
module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Instantiate separate modules for each output clock frequency
clk_div_2 u_clk_div_2 (
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_50)
);

clk_div_n #(.DIVISION_FACTOR(10)) u_clk_div_10 (
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_10)
);

clk_div_n #(.DIVISION_FACTOR(100)) u_clk_div_100 (
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_1)
);

endmodule

// Module clk_div_2
module clk_div_2 (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_out // Output clock signal with a frequency of CLK_in divided by 2
);

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_out <= 1'b0;
    end else begin
        CLK_out <= ~CLK_out;
    end
end

endmodule

// Module clk_div_n
module clk_div_n #(
    parameter DIVISION_FACTOR = 10
) (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_out // Output clock signal with a frequency of CLK_in divided by DIVISION_FACTOR
);

reg [$clog2(DIVISION_FACTOR)-1:0] counter;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        counter <= 0;
        CLK_out <= 1'b0;
    end else begin
        if (counter == DIVISION_FACTOR - 1) begin
            counter <= 0;
            CLK_out <= ~CLK_out;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

endmodule