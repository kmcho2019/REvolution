module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline enable signals: track mul_en_in through pipeline
    reg [2:0] en_pipe;

    // Stage 1: input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (combinational)
    wire [15:0] partial_products [7:0];

    // Stage 2: register partial products
    reg [15:0] pp_reg [7:0];

    // Stage 3: partial sum register
    reg [15:0] sum_reg;

    integer i;

    // Track enable through pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 3'b0;
        end else begin
            en_pipe <= {en_pipe[1:0], mul_en_in};
        end
    end

    // Input registers: latch inputs when enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Generate partial products combinationally based on registered inputs
    genvar idx;
    generate
        for (idx=0; idx<8; idx=idx+1) begin : gen_pp
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'b0;
        end
    endgenerate

    // Register partial products in pipeline stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= 16'b0;
        end else begin
            if (en_pipe[0]) begin
                for (i=0; i<8; i=i+1)
                    pp_reg[i] <= partial_products[i];
            end else begin
                for (i=0; i<8; i=i+1)
                    pp_reg[i] <= 16'b0;
            end
        end
    end

    // Sum partial products and register in pipeline stage 3
    wire [15:0] sum_partial = pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3] +
                              pp_reg[4] + pp_reg[5] + pp_reg[6] + pp_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg     <= 16'b0;
            mul_en_out  <= 1'b0;
            mul_out     <= 16'b0;
        end else begin
            if (en_pipe[1]) begin
                sum_reg <= sum_partial;
            end else begin
                sum_reg <= 16'b0;
            end

            mul_en_out <= en_pipe[2];
            mul_out    <= en_pipe[2] ? sum_reg : 16'b0;
        end
    end

endmodule