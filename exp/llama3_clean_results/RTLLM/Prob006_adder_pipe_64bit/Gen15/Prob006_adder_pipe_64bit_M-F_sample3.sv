// Define a 4-bit ripple carry adder with carry-lookahead
module rca_4bit(
    input   [3:0]  a,
    input   [3:0]  b,
    input           cin,
    output  [3:0]  sum,
    output          cout
);
    wire [3:0]    carry;

    // Calculate carry
    assign carry[0] = a[0] & b[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);

    // Calculate sum
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign sum[3] = a[3] ^ b[3] ^ carry[2];

    // Calculate cout
    assign cout = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);
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
    reg             i_en_reg;
    reg     [63:0]  adda_reg;
    reg     [63:0]  addb_reg;
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

    // Initialize sum and carry
    reg [3:0] sum_stage [15:0];
    reg [15:0] cout_stage;

    // Pipeline stages
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_stage <= '{default: 4'd0};
            cout_stage <= '{default: 1'b0};
        end else if (i_en) begin
            // Stage 1
            sum_stage[0] <= adda_reg[3:0] + addb_reg[3:0];
            cout_stage[0] <= (adda_reg[3] & addb_reg[3]) | (adda_reg[3] & (adda_reg[2] & addb_reg[2])) | (addb_reg[3] & (adda_reg[2] & addb_reg[2]));

            // Stage 2-15
            for (int i = 1; i < 16; i++) begin
                sum_stage[i] <= adda_reg[(i*4)+3:(i*4)] + addb_reg[(i*4)+3:(i*4)] + cout_stage[i-1];
                cout_stage[i] <= (adda_reg[(i*4)+3] & addb_reg[(i*4)+3]) | (adda_reg[(i*4)+3] & (adda_reg[(i*4)+2] & addb_reg[(i*4)+2])) | (addb_reg[(i*4)+3] & (adda_reg[(i*4)+2] & addb_reg[(i*4)+2]));
            end
        end
    end

    // Assign result
    assign result = {1'b0, sum_stage[15], sum_stage[14], sum_stage[13], sum_stage[12], sum_stage[11], sum_stage[10], sum_stage[9], sum_stage[8], sum_stage[7], sum_stage[6], sum_stage[5], sum_stage[4], sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};

    // Generate output enable signal
    assign o_en = i_en_reg;
endmodule