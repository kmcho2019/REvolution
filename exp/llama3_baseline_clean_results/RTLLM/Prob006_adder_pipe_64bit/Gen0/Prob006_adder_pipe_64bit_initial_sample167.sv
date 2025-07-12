module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output     [64:0] result,
    output             o_en
);

reg       [63:0] sum;
reg       [63:0] temp_sum;
reg               carry;
reg               temp_carry;
reg               o_en_reg;
reg               i_en_reg;
reg               i_en_reg2;

// Pipeline stage 1: input register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 1'b0;
        sum <= 64'b0;
        carry <= 1'b0;
    end else if (i_en) begin
        i_en_reg <= 1'b1;
        sum <= adda;
        carry <= 1'b0;
    end else begin
        i_en_reg <= i_en_reg;
        sum <= sum;
        carry <= carry;
    end
end

// Pipeline stage 2: adder
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        temp_sum <= 64'b0;
        temp_carry <= 1'b0;
    end else if (i_en_reg) begin
        {temp_carry, temp_sum} <= sum + addb + carry;
    end else begin
        temp_sum <= temp_sum;
        temp_carry <= temp_carry;
    end
end

// Pipeline stage 3: output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'b0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        result <= {temp_carry, temp_sum};
        o_en_reg <= 1'b1;
    end else begin
        result <= result;
        o_en_reg <= o_en_reg;
    end
end

// Pipeline stage 4: output enable
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg2 <= 1'b0;
        o_en <= 1'b0;
    end else if (i_en_reg) begin
        i_en_reg2 <= 1'b1;
        o_en <= 1'b0;
    end else if (i_en_reg2) begin
        i_en_reg2 <= 1'b0;
        o_en <= o_en_reg;
    end else begin
        i_en_reg2 <= i_en_reg2;
        o_en <= o_en;
    end
end

endmodule