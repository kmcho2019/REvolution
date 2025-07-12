module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Generic counter module
module counter(
    input CLK,    // Input clock signal
    input RST,   // Reset signal
    input [7:0] div_factor,  // Division factor
    output reg CLK_out  // Output clock signal
);
    reg [7:0] counter_value;  // Counter value

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            counter_value <= 0;
            CLK_out <= 0;
        end else if(counter_value == div_factor - 1) begin
            counter_value <= 0;
            CLK_out <= ~CLK_out;
        end else begin
            counter_value <= counter_value + 1;
        end
    end
endmodule

// Instantiate counter modules for each output clock
counter #(.div_factor(2)) u_CLK_50(
   .CLK(CLK_in),
   .RST(RST),
   .CLK_out(CLK_50)
);

counter #(.div_factor(10)) u_CLK_10(
   .CLK(CLK_in),
   .RST(RST),
   .CLK_out(CLK_10)
);

counter #(.div_factor(100)) u_CLK_1(
   .CLK(CLK_in),
   .RST(RST),
   .CLK_out(CLK_1)
);

endmodule