module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    // Pipeline stages
    reg [1:0] stage;
    wire stage1_active = (stage == 2'd1);
    wire stage2_active = (stage == 2'd2);
    wire stage3_active = (stage == 2'd3);

    // Partial product generation
    reg [15:0] a_reg;
    reg [15:0] b_reg;
    wire [15:0][15:0] pp;  // 16 partial products (16 bits each)

    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? a_reg << i : 16'd0;
        end
    endgenerate

    // Carry-save reduction (first level)
    wire [31:0] sum1, carry1;
    assign sum1 = pp[0] + pp[1] + pp[2] + pp[3];
    assign carry1 = ((pp[0] ^ pp[1] ^ pp[2] ^ pp[3]) << 1);

    // PPA tree parameters
    localparam PPA_STAGES = 4;
    reg [31:0] ppa_sum [0:PPA_STAGES];
    reg [31:0] ppa_carry [0:PPA_STAGES];

    // Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage <= 2'd0;
            a_reg <= 16'd0;
            b_reg <= 16'd0;
            yout <= 32'd0;
        end else begin
            case (stage)
                2'd0: begin // IDLE
                    if (start) begin
                        a_reg <= ain;
                        b_reg <= bin;
                        stage <= 2'd1;
                    end
                end
                2'd1: begin // Partial product gen
                    ppa_sum[0] <= sum1 + pp[4] + pp[5] + pp[6] + pp[7];
                    ppa_carry[0] <= carry1 + ((pp[4] ^ pp[5] ^ pp[6] ^ pp[7]) << 1);
                    stage <= 2'd2;
                end
                2'd2: begin // PPA stage 1
                    ppa_sum[1] <= ppa_sum[0] ^ ppa_carry[0];
                    ppa_carry[1] <= (ppa_sum[0] & ppa_carry[0]) << 1;
                    stage <= 2'd3;
                end
                2'd3: begin // PPA stage 2 and output
                    yout <= ppa_sum[1] + ppa_carry[1] + 
                           pp[8] + pp[9] + pp[10] + pp[11] +
                           pp[12] + pp[13] + pp[14] + pp[15];
                    stage <= start ? 2'd1 : 2'd0;
                end
            endcase
        end
    end

    // Done signal generation
    assign done = stage3_active;

endmodule