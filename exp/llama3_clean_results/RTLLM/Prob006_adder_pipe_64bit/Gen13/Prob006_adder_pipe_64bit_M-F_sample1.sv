// Define a full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 64-bit ripple carry adder module
module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] sum_reg;
reg [1:0]  i_en_reg;
reg [63:0] sum_int;
reg [63:0] carry_int;

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 2'b00;
        o_en <= 1'b0;
        sum_int <= 64'd0;
        carry_int <= 64'd0;
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg[1]) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

// Calculate sum using full adder modules
genvar i;
generate
    for (i = 0; i < 64; i++) begin
        full_adder fa(
           .a(adda_reg[i]),
           .b(addb_reg[i]),
           .cin(i == 0? 1'b0 : carry_int[i-1]),
           .sum(sum_int[i]),
           .cout(carry_int[i])
        );
    end
endgenerate

// Update sum_reg with the calculated sum and carry
always @ (posedge clk) begin
    sum_reg <= {carry_int[63], sum_int};
end

// Assign result
assign result = sum_reg;

endmodule