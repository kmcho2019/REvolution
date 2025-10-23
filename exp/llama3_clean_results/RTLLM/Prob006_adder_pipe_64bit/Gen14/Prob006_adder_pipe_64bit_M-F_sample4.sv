// Define parameters for data width and pipeline stages
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 2;

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
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] sum_reg;
reg [STG_WIDTH-1:0]  i_en_reg;
reg [DATA_WIDTH-1:0] sum_int;
reg [DATA_WIDTH-1:0] carry_int;

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        i_en_reg <= {STG_WIDTH{1'b0}};
        o_en <= 1'b0;
        sum_int <= {DATA_WIDTH{1'b0}};
        carry_int <= {DATA_WIDTH{1'b0}};
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg[STG_WIDTH-1]) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

// Calculate sum using full adder modules
genvar i;
generate
    for (i = 0; i < DATA_WIDTH; i++) begin
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
    sum_reg <= {carry_int[DATA_WIDTH-1], sum_int};
end

// Assign result
assign result = sum_reg;

endmodule