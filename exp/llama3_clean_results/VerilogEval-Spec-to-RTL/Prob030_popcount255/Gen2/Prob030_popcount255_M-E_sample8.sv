module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Define the 4-bit population count circuit
function [1:0] popcount_4bit;
    input [3:0] in;
    begin
        popcount_4bit = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]};
    end
endfunction

// Define the 4:2 adder using carry-save adder (CSA)
module csa_4to2 (
    input  [1:0] a,
    input  [1:0] b,
    input  [1:0] c,
    input  [1:0] d,
    output [1:0] sum,
    output [1:0] carry
);
    assign sum = a + b + c + d;
    assign carry = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d);
endmodule

// Define the 4:1 multiplexor-based tree
module tree_4to1 (
    input  [1:0] a,
    input  [1:0] b,
    input  [1:0] c,
    input  [1:0] d,
    output [3:0] out
);
    reg [1:0] sum, carry;
    csa_4to2 csa_inst (
       .a(a),
       .b(b),
       .c(c),
       .d(d),
       .sum(sum),
       .carry(carry)
    );
    assign out = {carry, sum};
endmodule

// Define the final ripple-carry adder (RCA)
module rca_4to8 (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] out
);
    reg [3:0] sum;
    reg [3:0] carry;
    always @(*) begin
        sum = a + b;
        carry = (a & b);
        out = {carry[3], sum[3:0]};
    end
endmodule

// Instantiate the 4-bit population count circuits
reg [1:0] popcounts [63:0];
integer i;
always @(*) begin
    for (i = 0; i < 64; i++) begin
        popcounts[i] = popcount_4bit(in[(i*4)+3:i*4]);
    end
end

// Instantiate the 4:1 multiplexor-based tree
reg [3:0] tree_outs [15:0];
integer j;
always @(*) begin
    for (j = 0; j < 16; j++) begin
        tree_4to1 tree_inst (
           .a(popcounts[j*4]),
           .b(popcounts[j*4+1]),
           .c(popcounts[j*4+2]),
           .d(popcounts[j*4+3]),
           .out(tree_outs[j])
        );
    end
end

// Instantiate the final ripple-carry adder (RCA)
reg [7:0] rca_out;
always @(*) begin
    rca_4to8 rca_inst (
       .a(tree_outs[0]),
       .b(tree_outs[1]),
       .out(rca_out)
    );
    for (j = 2; j < 16; j++) begin
        rca_4to8 rca_inst2 (
           .a(rca_out),
           .b(tree_outs[j]),
           .out(rca_out)
        );
    end
end

assign out = rca_out;

endmodule