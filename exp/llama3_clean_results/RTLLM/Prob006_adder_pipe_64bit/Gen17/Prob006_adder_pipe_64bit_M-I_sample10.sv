// Define a 4-bit ripple carry adder stage
module rca_stage(
    input   [3:0]  a,
    input   [3:0]  b,
    input           cin,
    output  [3:0]  sum,
    output          cout
);
    assign sum = a + b + cin;
    assign cout = (a[3] & b[3]) | ((a[3] | b[3]) & (a[2] & b[2])) | ((a[3] | b[3]) & (a[2] | b[2]) & cin);
endmodule

// Define the 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);
    reg     [63:0]  adda_reg;
    reg     [63:0]  addb_reg;
    reg             i_en_reg;
    reg     [63:0]  sum_reg;
    reg             cout_reg;

    // Synchronize input enable signal
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            i_en_reg <= 1'b0;
        end else begin
            i_en_reg <= i_en;
        end
    end

    // Store input operands
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
        end else if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
    end

    // Define pipeline stages
    wire [3:0] sum_stage [15:0];
    wire [15:0] cout_stage;

    // Instantiate pipeline stages
    rca_stage stage0 (
       .a  (adda_reg[3:0]),
       .b  (addb_reg[3:0]),
       .cin(1'b0),
       .sum(sum_stage[0]),
       .cout(cout_stage[0])
    );

    generate
        for (genvar i = 1; i < 16; i++) begin
            rca_stage stage (
               .a  (adda_reg[(i*4)+3:(i*4)]),
               .b  (addb_reg[(i*4)+3:(i*4)]),
               .cin(cout_stage[i-1]),
               .sum(sum_stage[i]),
               .cout(cout_stage[i])
            );
        end
    endgenerate

    // Assign result
    assign result = {cout_stage[15], sum_stage[15], sum_stage[14], sum_stage[13], sum_stage[12], sum_stage[11], sum_stage[10], sum_stage[9], sum_stage[8], sum_stage[7], sum_stage[6], sum_stage[5], sum_stage[4], sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};

    // Generate output enable signal
    assign o_en = i_en_reg;
endmodule