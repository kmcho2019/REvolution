module adder_pipe_64bit(
    input           clk,        // Clock input
    input           rst_n,      // Active low reset signal
    input           i_en,       // Enable signal for addition operation
    input   [63:0]   adda,       // 64-bit input operand A
    input   [63:0]   addb,       // 64-bit input operand B
    output  [64:0]   result,    // 65-bit output representing the sum of adda and addb
    output          o_en        // Output enable signal
);

// Register to synchronize the input enable signal
reg     i_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Register to synchronize the input operands
reg     [63:0] adda_reg;
reg     [63:0] addb_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
    end else if (i_en_reg) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
    end
end

// Register to synchronize the sum value
reg     [64:0] sum_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 65'b0;
    end else if (i_en_reg) begin
        sum_reg <= {1'b0, adda_reg} + {1'b0, addb_reg};
    end else begin
        sum_reg <= sum_reg;
    end
end

// Output enable signal
reg     o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b0;
    end else if (sum_reg != 65'b0) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= o_en_reg;
    end
end

// Assign the output signals
assign result = sum_reg;
assign o_en = o_en_reg;

endmodule