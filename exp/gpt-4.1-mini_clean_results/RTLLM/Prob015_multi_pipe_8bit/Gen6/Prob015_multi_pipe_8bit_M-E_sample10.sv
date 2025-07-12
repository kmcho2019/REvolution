module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline enables through 4 stages
    reg [3:0] en_pipe;

    // Stage 1 input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 partial products registers (8 partial products)
    reg [15:0] pp_reg [7:0];

    // Stage 3 intermediate sums (adder tree level 1)
    reg [15:0] sum_lvl1 [3:0];

    // Stage 4 intermediate sums (adder tree level 2)
    reg [15:0] sum_lvl2 [1:0];

    // Stage 5 final sum register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            en_pipe <= {en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: generate and register partial products
    // Each partial product is mul_a_reg AND mul_b_reg bit, shifted by bit position
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i=0; i<8; i=i+1)
                pp_reg[i] <= 16'b0;
        end else begin
            if(en_pipe[0]) begin
                pp_reg[0] <= mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
                pp_reg[1] <= mul_b_reg[1] ? ({7'b0, mul_a_reg} << 1) : 16'b0;
                pp_reg[2] <= mul_b_reg[2] ? ({6'b0, mul_a_reg} << 2) : 16'b0;
                pp_reg[3] <= mul_b_reg[3] ? ({5'b0, mul_a_reg} << 3) : 16'b0;
                pp_reg[4] <= mul_b_reg[4] ? ({4'b0, mul_a_reg} << 4) : 16'b0;
                pp_reg[5] <= mul_b_reg[5] ? ({3'b0, mul_a_reg} << 5) : 16'b0;
                pp_reg[6] <= mul_b_reg[6] ? ({2'b0, mul_a_reg} << 6) : 16'b0;
                pp_reg[7] <= mul_b_reg[7] ? ({1'b0, mul_a_reg} << 7) : 16'b0;
            end else begin
                for(i=0; i<8; i=i+1)
                    pp_reg[i] <= 16'b0;
            end
        end
    end

    // Stage 3: sum partial products in pairs (level 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i=0; i<4; i=i+1)
                sum_lvl1[i] <= 16'b0;
        end else begin
            if(en_pipe[1]) begin
                sum_lvl1[0] <= pp_reg[0] + pp_reg[1];
                sum_lvl1[1] <= pp_reg[2] + pp_reg[3];
                sum_lvl1[2] <= pp_reg[4] + pp_reg[5];
                sum_lvl1[3] <= pp_reg[6] + pp_reg[7];
            end else begin
                for(i=0; i<4; i=i+1)
                    sum_lvl1[i] <= 16'b0;
            end
        end
    end

    // Stage 4: sum level 1 results in pairs (level 2)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lvl2[0] <= 16'b0;
            sum_lvl2[1] <= 16'b0;
        end else begin
            if(en_pipe[2]) begin
                sum_lvl2[0] <= sum_lvl1[0] + sum_lvl1[1];
                sum_lvl2[1] <= sum_lvl1[2] + sum_lvl1[3];
            end else begin
                sum_lvl2[0] <= 16'b0;
                sum_lvl2[1] <= 16'b0;
            end
        end
    end

    // Stage 5: sum level 2 results (final product)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            if(en_pipe[3]) begin
                mul_out_reg <= sum_lvl2[0] + sum_lvl2[1];
            end else begin
                mul_out_reg <= 16'b0;
            end
            mul_en_out <= en_pipe[3];
            mul_out <= en_pipe[3] ? mul_out_reg : 16'b0;
        end
    end

endmodule