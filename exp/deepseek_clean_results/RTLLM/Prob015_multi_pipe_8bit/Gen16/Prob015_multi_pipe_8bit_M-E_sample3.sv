module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control
    reg [2:0] en_pipe;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) en_pipe <= 3'b0;
        else en_pipe <= {en_pipe[1:0], mul_en_in};
    end
    assign mul_en_out = en_pipe[2];

    // Stage 1: Input registration and Booth encoding
    reg [7:0] a_reg, b_reg;
    wire [3:0] booth_sel [3:0];
    wire [8:0] booth_pp [3:0];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Booth encoder (radix-4)
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : booth_enc
            wire [2:0] b_group = (i==3) ? {b_reg[2*i+1], b_reg[2*i], 1'b0} : 
                                {b_reg[2*i+1], b_reg[2*i], b_reg[2*i-1]};
            
            assign booth_sel[i] = 
                (b_group == 3'b000 || b_group == 3'b111) ? 4'b0000 : // 0
                (b_group == 3'b001 || b_group == 3'b010) ? 4'b0001 : // +1
                (b_group == 3'b011) ? 4'b0010 :                     // +2
                (b_group == 3'b100) ? 4'b1110 :                      // -2
                (b_group == 3'b101 || b_group == 3'b110) ? 4'b1111 : // -1
                4'b0000;
            
            assign booth_pp[i] = 
                (booth_sel[i][3]) ? 
                (~{1'b0, (booth_sel[i][1] ? {a_reg, 1'b0} : a_reg}) + 1 : // negative
                {1'b0, (booth_sel[i][1] ? {a_reg, 1'b0} : a_reg)};       // positive
        end
    endgenerate

    // Stage 2: Partial product compression
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    wire [15:0] pp0 = {{7{booth_pp[0][8]}}, booth_pp[0]};
    wire [15:0] pp1 = {{5{booth_pp[1][8]}}, booth_pp[1], 2'b00};
    wire [15:0] pp2 = {{3{booth_pp[2][8]}}, booth_pp[2], 4'b0000};
    wire [15:0] pp3 = {{1{booth_pp[3][8]}}, booth_pp[3], 6'b000000};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
        end else if (en_pipe[0]) begin
            pp0_reg <= pp0;
            pp1_reg <= pp1;
            pp2_reg <= pp2;
            pp3_reg <= pp3;
        end
    end

    // Stage 3: Final addition
    reg [15:0] result_reg;
    wire [15:0] sum01 = pp0_reg + pp1_reg;
    wire [15:0] sum23 = pp2_reg + pp3_reg;
    wire [15:0] final_sum = sum01 + sum23;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) result_reg <= 16'b0;
        else if (en_pipe[1]) result_reg <= final_sum;
    end

    // Output
    assign mul_out = en_pipe[2] ? result_reg : 16'b0;

endmodule