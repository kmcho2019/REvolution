module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] sum;
reg [63:0] cout;
reg [64:0] final_sum;
reg o_en_reg;

assign result = final_sum;
assign o_en = o_en_reg;

// Combinational logic for full adder chain
wire [63:0] cin;
assign cin[0] = 1'b0;
for (genvar i = 1; i < 64; i++) begin
    assign cin[i] = cout[i-1];
end

// Full adder chain
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin
        full_adder fa(
          .a(adda[i]),
          .b(addb[i]),
          .cin(cin[i]),
          .sum(sum[i]),
          .cout(cout[i])
        );
    end
endgenerate

// Final stage addition
assign final_sum = {1'b0, sum} + {64{cout[63]}};

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

endmodule