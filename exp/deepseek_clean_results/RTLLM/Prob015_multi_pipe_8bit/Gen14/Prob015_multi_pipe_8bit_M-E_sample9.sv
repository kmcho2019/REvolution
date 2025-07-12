module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Booth encoder outputs
    wire [8:0] booth_enc [3:0];
    wire [1:0] booth_sel [3:0];
    wire booth_sign [3:0];

    // Generate Booth encoding (Radix-4)
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : booth_encoder
            localparam [2:0] b_group = (i == 3) ? {mul_b[2*i+1], mul_b[2*i], 1'b0} : 
                                       {mul_b[2*i+1], mul_b[2*i], mul_b[2*i-1]};
            
            always @(*) begin
                case (b_group)
                    3'b000, 3'b111: begin booth_sel[i] = 2'b00; booth_sign[i] = 1'b0; end
                    3'b001, 3'b010: begin booth_sel[i] = 2'b01; booth_sign[i] = 1'b0; end
                    3'b011:         begin booth_sel[i] = 2'b10; booth_sign[i] = 1'b0; end
                    3'b100:         begin booth_sel[i] = 2'b10; booth_sign[i] = 1'b1; end
                    3'b101, 3'b110: begin booth_sel[i] = 2'b01; booth_sign[i] = 1'b1; end
                endcase
            end
            
            assign booth_enc[i] = {booth_sign[i], {8{booth_sign[i]}} ^ 
                                 ((booth_sel[i] == 2'b01) ? mul_a :
                                  (booth_sel[i] == 2'b10) ? {mul_a, 1'b0} : 8'b0)};
        end
    endgenerate

    // Pipeline registers with clock gating
    reg [7:0] a_reg, b_reg;
    reg [16:0] pp_reg [3:0];  // Partial products with extra sign bit
    reg [16:0] csa_sum, csa_carry;
    reg [15:0] final_sum;
    reg [2:0] en_pipeline;

    // Clock gating cells
    wire clk_gated = clk & (mul_en_in | |en_pipeline);

    // Carry-save adder for first stage
    wire [16:0] sum0, carry0;
    assign {carry0, sum0} = pp_reg[0] + pp_reg[1] + pp_reg[2];

    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (int i = 0; i < 4; i = i + 1) pp_reg[i] <= 17'b0;
            csa_sum <= 17'b0;
            csa_carry <= 17'b0;
            final_sum <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Input registration and Booth encoding
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            
            // Stage 2: Partial product generation and shift
            for (int i = 0; i < 4; i = i + 1) begin
                pp_reg[i] <= {booth_enc[i], {(2*i){1'b0}}};
            end
            
            // Stage 3: Carry-save addition
            {csa_carry, csa_sum} <= {sum0[15:0], 1'b0} + carry0 + pp_reg[3];
            
            // Stage 4: Final addition (computed in parallel)
            final_sum <= csa_sum[16:1] + csa_carry[16:1];
            
            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    always @(*) begin
        mul_en_out = en_pipeline[2];
        mul_out = en_pipeline[2] ? final_sum : 16'b0;
    end

endmodule