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
reg         o_en_reg;
reg [63:0] sum_int;
reg [63:0] carry_int;

// Pipeline stage management and calculation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        o_en_reg <= 1'b0;
        sum_int <= 64'd0;
        carry_int <= 64'd0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        o_en_reg <= i_en;
        sum_int <= 64'd0;
        carry_int <= 64'd0;
        for (int i = 0; i < 64; i++) begin
            if (i == 0) begin
                sum_int[i] = adda_reg[i] ^ addb_reg[i];
                carry_int[i] = adda_reg[i] & addb_reg[i];
            end else begin
                sum_int[i] = adda_reg[i] ^ addb_reg[i] ^ carry_int[i-1];
                carry_int[i] = (adda_reg[i] & addb_reg[i]) | (adda_reg[i] & carry_int[i-1]) | (addb_reg[i] & carry_int[i-1]);
            end
        end
        sum_reg <= {carry_int[63], sum_int};
    end
end

// Assign result and output enable signal
assign result = sum_reg;
assign o_en = o_en_reg;

endmodule