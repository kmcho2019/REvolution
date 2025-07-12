module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input   [63:0]      adda,
    input   [63:0]      addb,
    output  [64:0]      result,
    output              o_en
);

// Internal signals and registers
reg   [63:0]    adda_reg;
reg   [63:0]    addb_reg;
reg   [63:0]    sum_reg [3:0];
reg   [63:0]    carry_reg [3:0];
reg               i_en_reg;
reg               o_en_reg;

// Pipeline stage 1: Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'b1;
    end
end

// Pipeline stage 2: Calculate sum and carry for each bit
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg[0] <= 64'd0;
        carry_reg[0] <= 64'd0;
    end else if (i_en_reg) begin
        sum_reg[0] <= adda_reg ^ addb_reg;
        carry_reg[0] <= (adda_reg & addb_reg) | ((adda_reg ^ addb_reg) & {64{1'b0}}); // Assuming 64-bit adder
    end
end

// Pipeline stage 3: Calculate sum and carry for each bit ( considering carry from previous bit)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg[1] <= 64'd0;
        carry_reg[1] <= 64'd0;
    end else if (i_en_reg) begin
        sum_reg[1] <= sum_reg[0] ^ carry_reg[0];
        carry_reg[1] <= (sum_reg[0] & carry_reg[0]) | (carry_reg[0] & {64{1'b0}});
    end
end

// Pipeline stage 4: Calculate sum and carry for each bit (considering carry from previous bit)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg[2] <= 64'd0;
        carry_reg[2] <= 64'd0;
    end else if (i_en_reg) begin
        sum_reg[2] <= sum_reg[1] ^ carry_reg[1];
        carry_reg[2] <= (sum_reg[1] & carry_reg[1]) | (carry_reg[1] & {64{1'b0}});
    end
end

// Pipeline stage 5: Calculate final sum and carry
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg[3] <= 64'd0;
        carry_reg[3] <= 64'd0;
    end else if (i_en_reg) begin
        sum_reg[3] <= sum_reg[2] ^ carry_reg[2];
        carry_reg[3] <= (sum_reg[2] & carry_reg[2]) | (carry_reg[2] & {64{1'b0}});
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
        result <= 65'd0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b1;
        result <= {1'b0, sum_reg[3]} + {64'd1, {63{1'b0}}};
    end else begin
        o_en_reg <= 1'b0;
        result <= 65'd0;
    end
end

assign o_en = o_en_reg;

endmodule