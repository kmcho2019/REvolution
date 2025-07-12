module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 0: input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_pipe [0:8]; // 9-stage enable pipeline to track valid data

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            for (i=0; i<=8; i=i+1) mul_en_pipe[i] <= 1'b0;
        end else begin
            // Shift enable pipeline
            for (i=8; i>0; i=i-1)
                mul_en_pipe[i] <= mul_en_pipe[i-1];
            mul_en_pipe[0] <= mul_en_in;

            // Register inputs when input enable is high
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Partial products (combinational)
    wire [15:0] partial_products [7:0];
    genvar gi;
    generate
        for (gi = 0; gi < 8; gi = gi + 1) begin : gen_pp
            assign partial_products[gi] = mul_b_reg[gi] ? (mul_a_reg << gi) : 16'd0;
        end
    endgenerate

    // Pipeline registers to accumulate partial sums one by one
    reg [15:0] sum_reg [0:7];

    // At pipeline stage 1: sum_reg[0] = partial_products[0]
    // At stage n (n=1..7): sum_reg[n] = sum_reg[n-1] + partial_products[n]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1)
                sum_reg[i] <= 16'd0;
        end else begin
            if (mul_en_pipe[0]) begin
                // Load first partial product at stage 1
                sum_reg[0] <= partial_products[0];
            end else begin
                sum_reg[0] <= 16'd0;
            end

            for (i=1; i<8; i=i+1) begin
                if (mul_en_pipe[i]) begin
                    sum_reg[i] <= sum_reg[i-1] + partial_products[i];
                end else begin
                    sum_reg[i] <= 16'd0;
                end
            end
        end
    end

    // Register final output product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_out <= 1'b0;
        end else begin
            mul_out_reg <= sum_reg[7];
            mul_en_out <= mul_en_pipe[8]; // Output enable from last pipeline stage
        end
    end

    // Output assignment
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule