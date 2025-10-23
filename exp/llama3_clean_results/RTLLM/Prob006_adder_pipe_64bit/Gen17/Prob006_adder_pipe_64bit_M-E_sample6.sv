// Define a 4-bit full adder
module full_adder(
    input   [3:0]  a,
    input   [3:0]  b,
    input           cin,
    output  [3:0]  sum,
    output          cout
);
    assign sum = a + b + cin;
    assign cout = (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin);
endmodule

// Define a carry-lookahead module
module carry_lookahead(
    input   [15:0]  cin,
    output  [15:0]  cout
);
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            if (i == 0) begin
                assign cout[i] = cin[i];
            end else begin
                assign cout[i] = cin[i] | cout[i-1];
            end
        end
    endgenerate
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
    reg     [15:0]  cin_reg;
    reg     [15:0]  cout_reg;

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

    // Calculate sum and carry for each segment
    wire [3:0] sum_seg [15:0];
    wire [15:0] cin_seg;
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            full_adder fa (
                .a  (adda_reg[(i*4)+3:(i*4)]),
                .b  (addb_reg[(i*4)+3:(i*4)]),
                .cin(cin_seg[i]),
                .sum(sum_seg[i]),
                .cout(cout_reg[i])
            );
        end
    endgenerate

    // Propagate carry signals
    carry_lookahead cl (
        .cin(cout_reg),
        .cout(cin_seg)
    );

    // Form result
    assign result = {1'b0, sum_seg[15], sum_seg[14], sum_seg[13], sum_seg[12], sum_seg[11], sum_seg[10], sum_seg[9], sum_seg[8], sum_seg[7], sum_seg[6], sum_seg[5], sum_seg[4], sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]};

    // Generate output enable signal
    assign o_en = i_en_reg;
endmodule