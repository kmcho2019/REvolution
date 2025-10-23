module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// 1-bit full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit ripple carry adder
wire [63:0] sum;
wire [63:0] carry;

full_adder fa0(
   .a(adda[0]),
   .b(addb[0]),
   .cin(1'b0),
   .sum(sum[0]),
   .cout(carry[0])
);

generate
    for (genvar i = 1; i < 64; i++) begin
        full_adder fa(
           .a(adda[i]),
           .b(addb[i]),
           .cin(carry[i-1]),
           .sum(sum[i]),
           .cout(carry[i])
        );
    end
endgenerate

// Pipeline stages
reg [63:0] sum_pipe;
reg [63:0] carry_pipe;
reg i_en_pipe;
reg o_en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_pipe <= 64'b0;
        carry_pipe <= 64'b0;
        i_en_pipe <= 1'b0;
        o_en_pipe <= 1'b0;
    end else begin
        sum_pipe <= sum;
        carry_pipe <= carry;
        i_en_pipe <= i_en;
        o_en_pipe <= i_en_pipe;
    end
end

// Output result
assign result = {carry[63], sum_pipe};

// Output enable signal
assign o_en = o_en_pipe;

endmodule