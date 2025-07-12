// Define a full adder module with reduced logic gates
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

// Define the adder pipeline module with optimized logic and registers
module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define parameters for the module
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 1;

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH-1:0] sum;
reg [DATA_WIDTH-1:0] couts;
reg [DATA_WIDTH:0]  final_sum;
reg        o_en_reg;
reg        prev_i_en;

assign result = final_sum;
assign o_en = o_en_reg;

// Register inputs
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        o_en_reg <= 1'b0;
        prev_i_en <= 1'b0;
    end else begin
        adda_reg <= adda;
        addb_reg <= addb;
        prev_i_en <= i_en;
        if (prev_i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

// Combinational logic for full adder chain
wire [DATA_WIDTH-1:0] cin;
assign cin[0] = 1'b0;
for (genvar i = 1; i < DATA_WIDTH; i++) begin
    assign cin[i] = couts[i-1];
end

// Full adder chain
genvar i;
generate
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
        full_adder fa(
         .a(adda_reg[i]),
         .b(addb_reg[i]),
         .cin(cin[i]),
         .sum(sum[i]),
         .cout(couts[i])
        );
    end
endgenerate

// Final stage addition
assign final_sum = {1'b0, sum} + {DATA_WIDTH+1{couts[DATA_WIDTH-1]}};

endmodule