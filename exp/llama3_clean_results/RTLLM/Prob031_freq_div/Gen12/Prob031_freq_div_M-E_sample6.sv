module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Parameterized clock divider module
module clock_divider(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_out,  // Output clock signal
    parameter DIVISOR = 2  // Divisor for clock division
);
    reg [31:0] counter;  // Counter for clock division

    always @(posedge CLK_in or posedge RST) begin
        if(RST) begin
            // Reset counter and output clock
            counter <= 0;
            CLK_out <= 0;
        end else begin
            // Increment counter and toggle output clock
            counter <= (counter == DIVISOR - 1) ? 0 : counter + 1;
            CLK_out <= (counter == DIVISOR - 1) ? ~CLK_out : CLK_out;
        end
    end
endmodule

// Instantiate clock divider modules for each output clock
clock_divider clk_div_50(
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_50),
    .DIVISOR(2)
);

clock_divider clk_div_10(
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_10),
    .DIVISOR(10)
);

clock_divider clk_div_1(
    .CLK_in(CLK_in),
    .RST(RST),
    .CLK_out(CLK_1),
    .DIVISOR(100)
);

endmodule