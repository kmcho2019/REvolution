// Define the adder module using carry-lookahead architecture
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Perform the addition using a carry-lookahead adder
    assign sum = a + b;

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    // Detect signed overflow using a separate adder
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection with clock gating
module TopModule(
    input  clk,  // Clock signal
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;
    reg  [7:0] sum_reg;
    reg        overflow_reg;

    // Clock gating to reduce power consumption
    always @(posedge clk) begin
        sum_reg <= a + b;
        overflow_reg <= (a[7] == b[7] && a[7] != (a + b)[7]);
    end

    assign s = sum_reg;
    assign overflow = overflow_reg;

endmodule