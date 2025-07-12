module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stages count: 5 (input register + 3 add pipeline + output reg)
    // mul_en_out_reg is 5 bits to track enable propagation along pipeline
    reg [4:0] mul_en_out_reg;

    // Input registers for operands, updated only when mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Register partial products to break combinational path and reduce toggling
    reg [15:0] pp_reg [7:0];

    // Pipeline stage 1 sums
    reg [15:0] sum0, sum1, sum2, sum3;
    // Pipeline stage 2 sums
    reg [15:0] sum01, sum23;
    // Final output register
    reg [15:0] mul_out_reg;

    integer i;

    // Input enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 5'b0;
        else
            mul_en_out_reg <= {mul_en_out_reg[3:0], mul_en_in};
    end

    // Input registers loaded only when mul_en_in asserted to reduce toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Generate partial products combinationally, then register them (to reduce path delay)
    // pp[i] = (mul_b_reg[i] ? mul_a_reg << i : 0)
    wire [15:0] pp_comb[7:0];
    genvar gi;
    generate
        for (gi=0; gi<8; gi=gi+1) begin : PP_GEN
            assign pp_comb[gi] = mul_b_reg[gi] ? (mul_a_reg << gi) : 16'd0;
        end
    endgenerate

    // Register the partial products only when mul_en_out_reg[0] asserted (valid data)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else if (mul_en_out_reg[0]) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= pp_comb[i];
        end else begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end
    end

    // Pipeline Stage 1: pairwise addition of partial products (sum0..sum3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'd0;
            sum1 <= 16'd0;
            sum2 <= 16'd0;
            sum3 <= 16'd0;
        end else if (mul_en_out_reg[1]) begin
            sum0 <= pp_reg[0] + pp_reg[1];
            sum1 <= pp_reg[2] + pp_reg[3];
            sum2 <= pp_reg[4] + pp_reg[5];
            sum3 <= pp_reg[6] + pp_reg[7];
        end else begin
            sum0 <= 16'd0;
            sum1 <= 16'd0;
            sum2 <= 16'd0;
            sum3 <= 16'd0;
        end
    end

    // Pipeline Stage 2: add results of stage 1 pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 16'd0;
            sum23 <= 16'd0;
        end else if (mul_en_out_reg[2]) begin
            sum01 <= sum0 + sum1;
            sum23 <= sum2 + sum3;
        end else begin
            sum01 <= 16'd0;
            sum23 <= 16'd0;
        end
    end

    // Pipeline Stage 3: final addition and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_out_reg[3])
            mul_out_reg <= sum01 + sum23;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable signal - valid when output register holds valid product
    assign mul_en_out = mul_en_out_reg[4];

    // Output mux: register output is zeroed when not valid to avoid glitches
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule