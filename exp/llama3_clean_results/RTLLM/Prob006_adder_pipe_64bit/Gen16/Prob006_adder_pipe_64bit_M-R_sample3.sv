// Define a 4-bit ripple carry adder module
module rca_4bit(
    input   [3:0]  a,
    input   [3:0]  b,
    input           cin,
    output  [3:0]  sum,
    output          cout
);
    assign sum = a + b + cin;
    assign cout = (a[3] & b[3]) | (a[3] & (a[2] & b[2])) | (b[3] & (a[2] & b[2]));
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
    reg     [64:0]  result_reg;
    reg             o_en_reg;

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

    // Pipeline stages
    wire [3:0] sum [15:0];
    wire [15:0] cout;

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            if (i == 0) begin
                rca_4bit u_rca_4bit(
                   .a(adda_reg[(i*4)+3:(i*4)]),
                   .b(addb_reg[(i*4)+3:(i*4)]),
                   .cin(1'b0),
                   .sum(sum[i]),
                   .cout(cout[i])
                );
            end else begin
                rca_4bit u_rca_4bit(
                   .a(adda_reg[(i*4)+3:(i*4)]),
                   .b(addb_reg[(i*4)+3:(i*4)]),
                   .cin(cout[i-1]),
                   .sum(sum[i]),
                   .cout(cout[i])
                );
            end
        end
    endgenerate

    // Assign result
    assign result_reg = {1'b0, sum[15], sum[14], sum[13], sum[12], sum[11], sum[10], sum[9], sum[8], sum[7], sum[6], sum[5], sum[4], sum[3], sum[2], sum[1], sum[0]};

    // Generate output enable signal
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            o_en_reg <= 1'b0;
        end else if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end

    // Assign output
    assign result = result_reg;
    assign o_en = o_en_reg;
endmodule