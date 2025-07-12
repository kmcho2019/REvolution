module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    reg [15:0] adda_s1, addb_s1;
    reg [15:0] adda_s2, addb_s2;
    reg [15:0] adda_s3, addb_s3;
    reg [15:0] adda_s4, addb_s4;

    reg [15:0] sum_s1, sum_s2, sum_s3, sum_s4;
    reg        carry_s0; // carry-in stage 1
    reg        carry_s1, carry_s2, carry_s3, carry_s4;

    reg        valid_s1, valid_s2, valid_s3, valid_s4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_s1 <= 16'b0; addb_s1 <= 16'b0;
            adda_s2 <= 16'b0; addb_s2 <= 16'b0;
            adda_s3 <= 16'b0; addb_s3 <= 16'b0;
            adda_s4 <= 16'b0; addb_s4 <= 16'b0;

            sum_s1 <= 16'b0; sum_s2 <= 16'b0; sum_s3 <= 16'b0; sum_s4 <= 16'b0;

            carry_s0 <= 1'b0;
            carry_s1 <= 1'b0; carry_s2 <= 1'b0; carry_s3 <= 1'b0; carry_s4 <= 1'b0;

            valid_s1 <= 1'b0; valid_s2 <= 1'b0; valid_s3 <= 1'b0; valid_s4 <= 1'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1 load operands and carry-in
            if (i_en) begin
                adda_s1 <= adda[15:0];
                addb_s1 <= addb[15:0];
            end
            carry_s0 <= 1'b0;       // initial carry-in zero
            valid_s1 <= i_en;

            // Stage 1 addition
            {carry_s1, sum_s1} <= adda_s1 + addb_s1 + carry_s0;

            // Stage 2 load operands
            if (valid_s1) begin
                adda_s2 <= adda[31:16];
                addb_s2 <= addb[31:16];
            end
            valid_s2 <= valid_s1;

            // Stage 2 addition
            {carry_s2, sum_s2} <= adda_s2 + addb_s2 + carry_s1;

            // Stage 3 load operands
            if (valid_s2) begin
                adda_s3 <= adda[47:32];
                addb_s3 <= addb[47:32];
            end
            valid_s3 <= valid_s2;

            // Stage 3 addition
            {carry_s3, sum_s3} <= adda_s3 + addb_s3 + carry_s2;

            // Stage 4 load operands
            if (valid_s3) begin
                adda_s4 <= adda[63:48];
                addb_s4 <= addb[63:48];
            end
            valid_s4 <= valid_s3;

            // Stage 4 addition
            {carry_s4, sum_s4} <= adda_s4 + addb_s4 + carry_s3;

            // Output result and enable when valid_s4 asserted
            if (valid_s4) begin
                result <= {carry_s4, sum_s4, sum_s3, sum_s2, sum_s1};
            end
            o_en <= valid_s4;
        end
    end

endmodule