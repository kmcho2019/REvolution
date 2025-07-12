// Define the adder module using a ripple-carry adder
module RippleCarryAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    wire [7:0] carry;

    assign sum[0] = a[0] ^ b[0];
    assign carry[0] = a[0] & b[0];

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    // Detect signed overflow using a separate adder
    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    // Apply clock gating to reduce power consumption
    reg clk;
    always @(posedge clk) begin
        RippleCarryAdder adder(
           .a(a),
           .b(b),
           .sum(sum)
        );

        OverflowDetector detector(
           .a(a),
           .b(b),
           .sum(sum),
           .overflow(overflow)
        );

        assign s = sum;
    end

endmodule