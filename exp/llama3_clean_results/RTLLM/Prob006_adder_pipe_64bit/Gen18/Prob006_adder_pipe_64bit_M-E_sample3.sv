module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

    // Define the number of segments
    localparam NUM_SEGMENTS = 16;

    // Define the width of each segment
    localparam SEGMENT_WIDTH = 4;

    // Define the width of the result
    localparam RESULT_WIDTH = 65;

    // Register to store the input operands
    reg [63:0] adda_reg;
    reg [63:0] addb_reg;

    // Register to store the intermediate results
    reg [NUM_SEGMENTS-1:0][SEGMENT_WIDTH-1:0] sum_reg;
    reg [NUM_SEGMENTS-1:0] cout_reg;

    // Register to store the final result
    reg [RESULT_WIDTH-1:0] result_reg;

    // Register to store the output enable signal
    reg o_en_reg;

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
    wire [SEGMENT_WIDTH-1:0] sum_stage [NUM_SEGMENTS-1:0];
    wire [NUM_SEGMENTS-1:0] cout_stage;

    // Instantiate pipeline stages
    for (genvar i = 0; i < NUM_SEGMENTS; i++) begin
        if (i == 0) begin
            // First stage
            rca_stage stage0 (
                .a  (adda_reg[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH]),
                .b  (addb_reg[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH]),
                .cin(1'b0),
                .sum(sum_stage[i]),
                .cout(cout_stage[i])
            );
        end else begin
            // Subsequent stages
            rca_stage stage (
                .a  (adda_reg[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH]),
                .b  (addb_reg[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH]),
                .cin(cout_stage[i-1]),
                .sum(sum_stage[i]),
                .cout(cout_stage[i])
            );
        end
    end

    // Assign intermediate results
    always @ (posedge clk) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            sum_reg[i] <= sum_stage[i];
            cout_reg[i] <= cout_stage[i];
        end
    end

    // Assign final result
    always @ (posedge clk) begin
        result_reg <= {cout_stage[NUM_SEGMENTS-1], sum_reg[NUM_SEGMENTS-1], sum_reg[NUM_SEGMENTS-2], sum_reg[NUM_SEGMENTS-3], sum_reg[NUM_SEGMENTS-4], sum_reg[NUM_SEGMENTS-5], sum_reg[NUM_SEGMENTS-6], sum_reg[NUM_SEGMENTS-7], sum_reg[NUM_SEGMENTS-8], sum_reg[NUM_SEGMENTS-9], sum_reg[NUM_SEGMENTS-10], sum_reg[NUM_SEGMENTS-11], sum_reg[NUM_SEGMENTS-12], sum_reg[NUM_SEGMENTS-13], sum_reg[NUM_SEGMENTS-14], sum_reg[NUM_SEGMENTS-15]};
    end

    // Assign output enable signal
    always @ (posedge clk) begin
        o_en_reg <= i_en_reg;
    end

    // Output assignments
    assign result = result_reg;
    assign o_en = o_en_reg;

endmodule

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