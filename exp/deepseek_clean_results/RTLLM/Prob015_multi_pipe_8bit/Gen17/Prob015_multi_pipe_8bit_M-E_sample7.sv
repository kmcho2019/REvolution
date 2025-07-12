module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control signals
    reg [3:0] en_pipeline;
    assign mul_en_out = en_pipeline[3];

    // Booth encoding signals
    wire [8:0] b_ext = {mul_b, 1'b0};
    wire [2:0] booth_bits [3:0];
    
    assign booth_bits[0] = b_ext[2:0];
    assign booth_bits[1] = b_ext[4:2];
    assign booth_bits[2] = b_ext[6:4];
    assign booth_bits[3] = b_ext[8:6];

    // Pipeline stage 1: Input and Booth encoding
    reg [7:0] a_stage1;
    reg [8:0] b_stage1;
    reg [15:0] pp [3:0];
    reg en_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_stage1 <= 8'b0;
            b_stage1 <= 9'b0;
            en_stage1 <= 1'b0;
            en_pipeline <= 4'b0;
        end else begin
            a_stage1 <= mul_a;
            b_stage1 <= b_ext;
            en_stage1 <= mul_en_in;
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Booth partial product generation
    always @(*) begin
        for (integer i = 0; i < 4; i = i + 1) begin
            case (booth_bits[i])
                3'b000, 3'b111: pp[i] = 16'b0;
                3'b001, 3'b010: pp[i] = {8'b0, a_stage1} << (2*i);
                3'b011:        pp[i] = {7'b0, a_stage1, 1'b0} << (2*i);
                3'b100:        pp[i] = ~{7'b0, a_stage1, 1'b0} << (2*i) + 1;
                3'b101, 3'b110: pp[i] = ~{8'b0, a_stage1} << (2*i) + 1;
            endcase
        end
    end

    // Pipeline stage 2: First CSA level
    reg [15:0] sum1, carry1;
    reg en_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 16'b0;
            carry1 <= 16'b0;
            en_stage2 <= 1'b0;
        end else if (en_stage1) begin
            {carry1, sum1} = pp[0] + pp[1];
            en_stage2 <= en_stage1;
        end else begin
            sum1 <= 16'b0;
            carry1 <= 16'b0;
            en_stage2 <= 1'b0;
        end
    end

    // Pipeline stage 3: Second CSA level
    reg [15:0] sum2, carry2;
    reg en_stage3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum2 <= 16'b0;
            carry2 <= 16'b0;
            en_stage3 <= 1'b0;
        end else if (en_stage2) begin
            {carry2, sum2} = sum1 + carry1 + pp[2] + pp[3];
            en_stage3 <= en_stage2;
        end else begin
            sum2 <= 16'b0;
            carry2 <= 16'b0;
            en_stage3 <= 1'b0;
        end
    end

    // Pipeline stage 4: Final addition
    reg [15:0] result;
    reg en_stage4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
            en_stage4 <= 1'b0;
        end else if (en_stage3) begin
            result <= sum2 + (carry2 << 1);
            en_stage4 <= en_stage3;
        end else begin
            result <= 16'b0;
            en_stage4 <= 1'b0;
        end
    end

    // Output assignment
    assign mul_out = en_stage4 ? result : 16'b0;

endmodule