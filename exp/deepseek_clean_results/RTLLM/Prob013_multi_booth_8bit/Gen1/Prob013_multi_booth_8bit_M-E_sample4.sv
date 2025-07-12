module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_a, stage1_b;
    reg [15:0] stage2_a, stage2_pp;
    reg [2:0] stage2_booth;
    reg [1:0] stage_count;
    
    // Pre-computed partial products
    wire [15:0] pp_A    = stage1_a;
    wire [15:0] pp_2A   = {stage1_a[14:0], 1'b0};
    wire [15:0] pp_negA = -stage1_a;
    wire [15:0] pp_neg2A = -{stage1_a[14:0], 1'b0};
    
    // Booth encoder
    wire [2:0] booth_code = {stage1_b[1:0], stage1_b[2]};
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Stage 1: Initialization
            stage1_a <= {{8{a[7]}}, a};
            stage1_b <= {{8{b[7]}}, b};
            stage2_a <= 0;
            stage2_pp <= 0;
            stage2_booth <= 0;
            p <= 0;
            rdy <= 0;
            stage_count <= 0;
        end else begin
            // Pipeline stage 1 -> stage 2
            stage2_a <= stage1_a;
            stage2_booth <= booth_code;
            
            // Booth encoding and partial product selection
            case (booth_code)
                3'b000, 3'b111: stage2_pp <= 0;
                3'b001, 3'b010: stage2_pp <= pp_A;
                3'b011:         stage2_pp <= pp_2A;
                3'b100:         stage2_pp <= pp_neg2A;
                3'b101, 3'b110: stage2_pp <= pp_negA;
            endcase
            
            // Pipeline stage 2 -> output
            if (stage_count < 4) begin
                p <= p + (stage2_pp << (stage_count * 2));
                stage1_a <= stage1_a << 2;
                stage1_b <= stage1_b >> 2;
                stage_count <= stage_count + 1;
                rdy <= 0;
            end else begin
                rdy <= 1;
            end
        end
    end

endmodule