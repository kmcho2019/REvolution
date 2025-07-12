module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine
    typedef enum logic [2:0] {
        IDLE,
        GEN_PP,
        ADD_L1,
        ADD_L2,
        ADD_L3,
        ADD_L4,
        FINISH
    } state_t;
    
    state_t state, next_state;
    
    // Early termination detection
    wire zero_case = (ain == 16'b0) || (bin == 16'b0);
    
    // Partial product generation
    reg [15:0] a_reg;
    reg [31:0] pp [15:0];  // 16 partial products
    
    // Adder tree registers
    reg [31:0] sum_l1 [7:0];
    reg [31:0] sum_l2 [3:0];
    reg [31:0] sum_l3 [1:0];
    reg [31:0] sum_l4;
    
    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = start ? GEN_PP : IDLE;
            GEN_PP:  next_state = zero_case ? FINISH : ADD_L1;
            ADD_L1:  next_state = ADD_L2;
            ADD_L2:  next_state = ADD_L3;
            ADD_L3:  next_state = ADD_L4;
            ADD_L4:  next_state = FINISH;
            FINISH:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 16'b0;
            for (int i=0; i<16; i++) pp[i] <= 32'b0;
            sum_l4 <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) a_reg <= ain;
                end
                
                GEN_PP: begin
                    for (int i=0; i<16; i++) begin
                        pp[i] <= bin[i] ? (ain << i) : 32'b0;
                    end
                end
                
                ADD_L1: begin
                    for (int i=0; i<8; i++) begin
                        sum_l1[i] <= pp[2*i] + pp[2*i+1];
                    end
                end
                
                ADD_L2: begin
                    for (int i=0; i<4; i++) begin
                        sum_l2[i] <= sum_l1[2*i] + sum_l1[2*i+1];
                    end
                end
                
                ADD_L3: begin
                    for (int i=0; i<2; i++) begin
                        sum_l3[i] <= sum_l2[2*i] + sum_l2[2*i+1];
                    end
                end
                
                ADD_L4: begin
                    sum_l4 <= sum_l3[0] + sum_l3[1];
                end
                
                FINISH: begin
                    yout <= zero_case ? 32'b0 : sum_l4;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule