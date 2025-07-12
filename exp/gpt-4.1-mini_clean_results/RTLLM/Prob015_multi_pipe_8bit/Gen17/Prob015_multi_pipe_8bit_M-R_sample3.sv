module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable signal shift register: 4 stages to cover all pipeline registers
    reg [3:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1 partial products
    wire [15:0] pp0 = mul_b_reg[0] ? (mul_a_reg << 0) : 16'd0;
    wire [15:0] pp1 = mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0;
    wire [15:0] pp2 = mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0;
    wire [15:0] pp3 = mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0;

    // Stage 1 registers for partial sum s1
    reg [15:0] s1;

    // Stage 2 partial products
    wire [15:0] pp4 = mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0;
    wire [15:0] pp5 = mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0;
    wire [15:0] pp6 = mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0;
    wire [15:0] pp7 = mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0;

    // Stage 2 registers for partial sum s2
    reg [15:0] s2;

    // Final product register
    reg [15:0] mul_out_reg;

    // Pipeline enable signal propagation and input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'd0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1: sum partial products [pp0..pp3]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            s1 <= pp0 + pp1 + pp2 + pp3;
        end else begin
            s1 <= 16'd0;
        end
    end

    // Stage 2: sum partial products [pp4..pp7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s2 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            s2 <= pp4 + pp5 + pp6 + pp7;
        end else begin
            s2 <= 16'd0;
        end
    end

    // Stage 3: final sum and register output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= s1 + s2;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable from pipeline enable MSB
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: valid product only if output enable asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule