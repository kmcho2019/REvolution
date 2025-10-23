module adder_pipe_64bit(
    input           clk, 
    input           rst_n, 
    input           i_en, 
    input   [63:0]  adda, 
    input   [63:0]  addb, 
    output  [64:0]  result, 
    output          o_en
);

    reg     [63:0]  pipe_adda;
    reg     [63:0]  pipe_addb;
    reg             pipe_i_en;
    reg     [64:0]  sum;
    reg             sum_valid;
    wire    [63:0]  adda_reg;
    wire    [63:0]  addb_reg;

    // Input registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pipe_adda  <= 64'd0;
            pipe_addb  <= 64'd0;
            pipe_i_en  <= 1'b0;
        end else if (i_en) begin
            pipe_adda  <= adda;
            pipe_addb  <= addb;
            pipe_i_en  <= 1'b1;
        end else begin
            pipe_adda  <= pipe_adda;
            pipe_addb  <= pipe_addb;
            pipe_i_en  <= pipe_i_en;
        end
    end

    assign adda_reg = pipe_adda;
    assign addb_reg = pipe_addb;

    // Ripple carry adder
    wire [63:0]  carry;
    assign carry[0] = 1'b0;
    wire [63:0]  sum_reg;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin: adder_stage
            assign sum_reg[i] = adda_reg[i] ^ addb_reg[i] ^ carry[i];
            assign carry[i+1] = (adda_reg[i] & addb_reg[i]) | (adda_reg[i] & carry[i]) | (addb_reg[i] & carry[i]);
        end
    endgenerate

    assign result[63:0] = sum_reg;
    assign result[64]   = carry[63];

    // Output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            o_en <= 1'b0;
        end else if (pipe_i_en) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum <= 65'd0;
        end else if (o_en) begin
            sum <= result;
        end else begin
            sum <= sum;
        end
    end

endmodule