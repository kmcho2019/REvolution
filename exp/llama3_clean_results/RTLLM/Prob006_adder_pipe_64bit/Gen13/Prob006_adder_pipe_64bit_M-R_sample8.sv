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
reg        prev_i_en;

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        prev_i_en <= 1'b0;
        o_en <= 1'b0;
    end else begin
        prev_i_en <= i_en;
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        o_en <= prev_i_en;
    end
end

// Calculate sum using full adder logic
reg [63:0] sum_int;
always @ (*) begin
    sum_int[0] = adda_reg[0] ^ addb_reg[0];
    for (int i = 1; i < 64; i++) begin
        sum_int[i] = adda_reg[i] ^ addb_reg[i] ^ (adda_reg[i-1] & addb_reg[i-1]) | (adda_reg[i-1] & sum_int[i-1]) | (addb_reg[i-1] & sum_int[i-1]);
    end
end

// Assign result
assign result = {1'b0, sum_int};

endmodule