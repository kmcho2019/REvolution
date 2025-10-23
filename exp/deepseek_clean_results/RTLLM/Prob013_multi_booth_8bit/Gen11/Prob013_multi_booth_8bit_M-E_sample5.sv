module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_multiplicand, stage1_multiplier;
    reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
    reg [15:0] stage3_sum, stage3_carry;
    
    // Control signals
    reg [1:0] counter;
    reg [1:0] pipeline_state;
    
    // Constants
    localparam IDLE = 2'b00;
    localparam STAGE1 = 2'b01;
    localparam STAGE2 = 2'b10;
    localparam STAGE3 = 2'b11;
    
    // Booth encoding wires
    wire [2:0] booth_bits [0:3];
    wire [15:0] multiplicand_x2 = {stage1_multiplicand[14:0], 1'b0};
    wire [15:0] multiplicand_neg = ~stage1_multiplicand + 1;
    wire [15:0] multiplicand_x2_neg = ~multiplicand_x2 + 1;
    
    // Generate all possible partial products in parallel
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_encoders
            assign booth_bits[i] = (i == 0) ? {stage1_multiplier[1:0], 1'b0} :
                                 {stage1_multiplier[2*i+1:2*i], stage1_multiplier[2*i-1]};
            
            // Partial product selection muxes
            always @(*) begin
                case (booth_bits[i])
                    3'b000, 3'b111: stage2_pp0 = 16'b0;
                    3'b001, 3'b010: stage2_pp0 = stage1_multiplicand;
                    3'b011:         stage2_pp0 = multiplicand_x2;
                    3'b100:         stage2_pp0 = multiplicand_x2_neg;
                    default:        stage2_pp0 = multiplicand_neg;
                endcase
            end
        end
    endgenerate
    
    // Pipeline control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all pipeline registers
            stage1_multiplicand <= 16'b0;
            stage1_multiplier <= 16'b0;
            stage2_pp0 <= 16'b0;
            stage2_pp1 <= 16'b0;
            stage2_pp2 <= 16'b0;
            stage2_pp3 <= 16'b0;
            stage3_sum <= 16'b0;
            stage3_carry <= 16'b0;
            
            // Reset control signals
            counter <= 2'b0;
            pipeline_state <= IDLE;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            case (pipeline_state)
                IDLE: begin
                    // Initialize pipeline
                    stage1_multiplicand <= {{8{a[7]}}, a};
                    stage1_multiplier <= {{8{b[7]}}, b};
                    pipeline_state <= STAGE1;
                    counter <= 2'b0;
                    rdy <= 1'b0;
                end
                
                STAGE1: begin
                    // Booth encoding happens combinatorially
                    // Shift multiplier for next group
                    stage1_multiplier <= stage1_multiplier >>> 2;
                    pipeline_state <= STAGE2;
                end
                
                STAGE2: begin
                    // Carry-save addition of partial products
                    {stage3_carry, stage3_sum} = 
                        {stage2_pp0, 16'b0} + 
                        {stage2_pp1, 14'b0} + 
                        {stage2_pp2, 12'b0} + 
                        {stage2_pp3, 10'b0};
                    
                    if (counter == 2'b11) begin
                        pipeline_state <= STAGE3;
                    end else begin
                        counter <= counter + 1;
                        pipeline_state <= STAGE1;
                    end
                end
                
                STAGE3: begin
                    // Final addition and output
                    p <= stage3_sum + stage3_carry;
                    rdy <= 1'b1;
                    pipeline_state <= IDLE;
                end
            endcase
        end
    end

endmodule