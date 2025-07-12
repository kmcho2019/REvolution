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
    reg [1:0] en_pipe;
    assign mul_en_out = en_pipe[1];

    // Stage 1: Booth encoding and partial product generation
    reg [7:0] a_reg;
    reg [8:0] b_ext; // Extended for booth encoding
    wire [16:0] pp [3:0]; // Partial products (17 bits to handle sign extension)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_ext <= 9'b0;
            en_pipe <= 2'b0;
        end else begin
            en_pipe <= {en_pipe[0], mul_en_in};
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_ext <= {mul_b, 1'b0}; // Append 0 for booth encoding
            end
        end
    end

    // Booth encoder and partial product generator
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : booth_encoder
            wire [2:0] booth_bits = b_ext[i*2+2:i*2];
            wire [8:0] pp_val;
            wire neg;

            // Booth encoding logic
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: pp_val = 9'b0;  // 0
                    3'b001, 3'b010: pp_val = {1'b0, a_reg};  // +1
                    3'b011:         pp_val = {a_reg, 1'b0};  // +2
                    3'b100:         pp_val = ~{a_reg, 1'b0} + 1; // -2
                    3'b101, 3'b110: pp_val = ~{1'b0, a_reg} + 1; // -1
                endcase
                neg = booth_bits[2] & (|booth_bits[1:0]);
            end

            // Partial product with sign extension
            assign pp[i] = {{8{neg}}, pp_val, {i*2{1'b0}}};
        end
    endgenerate

    // Stage 2: Wallace tree compression and final addition
    reg [15:0] product;

    // First level compression (4:2)
    wire [16:0] sum1 = pp[0] + pp[1];
    wire [16:0] sum2 = pp[2] + pp[3];
    wire [16:0] carry1 = (pp[0] & pp[1]) << 1;
    wire [16:0] carry2 = (pp[2] & pp[3]) << 1;

    // Second level compression (2:1)
    wire [16:0] final_sum = sum1 + sum2 + carry1 + carry2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 16'b0;
        end else if (en_pipe[0]) begin
            product <= final_sum[15:0];
        end
    end

    assign mul_out = mul_en_out ? product : 16'b0;

endmodule