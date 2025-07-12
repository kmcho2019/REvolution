module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stage registers
    reg [15:0] stage1_multiplicand, stage1_multiplier;
    reg [3:0] stage1_counter;
    reg [15:0] stage2_pp [0:3];
    reg [15:0] stage2_sum, stage2_carry;
    reg [3:0] stage2_counter;
    
    // Internal signals
    wire [15:0] multiplicand_ext = {{8{a[7]}}, a};
    wire [15:0] multiplier_ext = {{8{b[7]}}, b};
    wire [2:0] booth_bits [0:3];
    wire [15:0] pp [0:3];
    wire [15:0] pp_neg [0:3];
    wire [15:0] pp_2x [0:3];
    wire [15:0] pp_neg2x [0:3];
    
    // State machine
    typedef enum logic [1:0] {
        IDLE,
        PROCESS,
        FINISH
    } state_t;
    
    state_t current_state, next_state;
    
    // Booth encoding bits
    assign booth_bits[0] = {stage1_multiplier[1:0], stage1_multiplier[1]};
    assign booth_bits[1] = {stage1_multiplier[3:2], stage1_multiplier[1]};
    assign booth_bits[2] = {stage1_multiplier[5:4], stage1_multiplier[3]};
    assign booth_bits[3] = {stage1_multiplier[7:6], stage1_multiplier[5]};
    
    // Partial product generation
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : pp_gen
            assign pp_2x[i] = stage1_multiplicand << 1;
            assign pp_neg[i] = -stage1_multiplicand;
            assign pp_neg2x[i] = -pp_2x[i];
            
            assign pp[i] = (booth_bits[i] == 3'b000 || booth_bits[i] == 3'b111) ? 16'b0 :
                          (booth_bits[i] == 3'b001 || booth_bits[i] == 3'b010) ? stage1_multiplicand :
                          (booth_bits[i] == 3'b011) ? pp_2x[i] :
                          (booth_bits[i] == 3'b100) ? pp_neg2x[i] : pp_neg[i];
        end
    endgenerate
    
    // Carry-save adder
    wire [15:0] csa_sum, csa_carry;
    assign csa_sum = stage2_pp[0] ^ stage2_pp[1] ^ stage2_pp[2];
    assign csa_carry = ((stage2_pp[0] & stage2_pp[1]) | 
                       (stage2_pp[0] & stage2_pp[2]) | 
                       (stage2_pp[1] & stage2_pp[2])) << 1;
    
    // Final adder
    wire [15:0] final_sum = stage2_sum + stage2_carry;
    
    // State machine control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            p <= 0;
            rdy <= 0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    p <= 0;
                    rdy <= 0;
                end
                
                PROCESS: begin
                    if (stage2_counter == 1) begin
                        p <= final_sum;
                        rdy <= 1;
                    end
                end
                
                FINISH: begin
                    rdy <= 0;
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = reset ? IDLE : PROCESS;
            PROCESS: next_state = (stage2_counter == 1) ? FINISH : PROCESS;
            FINISH: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Pipeline stage 1
    always @(posedge clk) begin
        if (current_state == IDLE && !reset) begin
            stage1_multiplicand <= multiplicand_ext;
            stage1_multiplier <= multiplier_ext;
            stage1_counter <= 0;
        end else if (current_state == PROCESS) begin
            stage1_counter <= stage1_counter + 1;
            stage1_multiplier <= stage1_multiplier >> 2;
        end
    end
    
    // Pipeline stage 2
    always @(posedge clk) begin
        if (current_state == PROCESS) begin
            stage2_pp[0] <= pp[0] << (stage1_counter * 2);
            stage2_pp[1] <= pp[1] << (stage1_counter * 2);
            stage2_pp[2] <= pp[2] << (stage1_counter * 2);
            stage2_counter <= stage1_counter;
            
            if (stage1_counter > 0) begin
                stage2_sum <= csa_sum;
                stage2_carry <= csa_carry;
            end else begin
                stage2_sum <= pp[0];
                stage2_carry <= 0;
            end
        end
    end

endmodule