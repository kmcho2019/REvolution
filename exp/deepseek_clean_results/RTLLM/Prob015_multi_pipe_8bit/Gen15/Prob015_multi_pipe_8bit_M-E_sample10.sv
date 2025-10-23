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
    reg [2:0] en_pipeline;
    assign mul_en_out = en_pipeline[2];

    // Booth encoding signals
    wire [8:0] b_ext = {mul_b, 1'b0};  // Extended multiplier for Booth
    wire [2:0] booth_sel [3:0];         // Booth select signals

    // Generate Booth encoding groups
    assign booth_sel[0] = b_ext[2:0];
    assign booth_sel[1] = b_ext[4:2];
    assign booth_sel[2] = b_ext[6:4];
    assign booth_sel[3] = b_ext[8:6];

    // Pipeline stage 1: Input registration
    reg [7:0] a_reg;
    reg [2:0] booth_reg [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            booth_reg[0] <= 3'b0;
            booth_reg[1] <= 3'b0;
            booth_reg[2] <= 3'b0;
            booth_reg[3] <= 3'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            booth_reg[0] <= booth_sel[0];
            booth_reg[1] <= booth_sel[1];
            booth_reg[2] <= booth_sel[2];
            booth_reg[3] <= booth_sel[3];
        end
    end

    // Partial product generation (Booth multiplexers)
    wire [8:0] pp [3:0];  // 9-bit partial products (including sign extension)
    
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : booth_mux
            always @(*) begin
                case (booth_reg[i])
                    3'b000, 3'b111: pp[i] = 9'b0;            // 0
                    3'b001, 3'b010: pp[i] = {1'b0, a_reg};   // +A
                    3'b011:         pp[i] = {a_reg, 1'b0};   // +2A
                    3'b100:         pp[i] = ~{a_reg, 1'b0};  // -2A
                    3'b101, 3'b110: pp[i] = ~{1'b0, a_reg};  // -A
                endcase
            end
        end
    endgenerate

    // Pipeline stage 2: Partial product alignment and first addition
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [15:0] sum01_reg, sum23_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
        end else if (en_pipeline[0]) begin
            // Sign extend and shift partial products
            pp0_reg <= {{7{pp[0][8]}}, pp[0]};
            pp1_reg <= {{5{pp[1][8]}}, pp[1], 2'b0};
            pp2_reg <= {{3{pp[2][8]}}, pp[2], 4'b0};
            pp3_reg <= {{1{pp[3][8]}}, pp[3], 6'b0};
            
            // First level additions
            sum01_reg <= pp0_reg + pp1_reg;
            sum23_reg <= pp2_reg + pp3_reg;
        end
    end

    // Pipeline stage 3: Final addition
    reg [15:0] result_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (en_pipeline[1]) begin
            result_reg <= sum01_reg + sum23_reg;
        end
    end

    // Enable signal pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    assign mul_out = mul_en_out ? result_reg : 16'b0;

endmodule