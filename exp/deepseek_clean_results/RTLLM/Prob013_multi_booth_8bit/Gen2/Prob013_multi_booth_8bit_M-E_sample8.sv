module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine definitions
    typedef enum logic [1:0] {
        IDLE,
        INIT,
        COMPUTE,
        DONE
    } state_t;
    
    state_t current_state, next_state;
    
    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [3:0] counter;
    reg [15:0] partial_product;
    
    // Booth encoding signals
    wire [2:0] booth_bits;
    wire [15:0] pp_2A = {multiplicand[14:0], 1'b0};
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -pp_2A;
    
    // State machine control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:    next_state = reset ? IDLE : INIT;
            INIT:    next_state = COMPUTE;
            COMPUTE: next_state = (counter == 4) ? DONE : COMPUTE;
            DONE:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Datapath operations
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                p <= 0;
                rdy <= 0;
                counter <= 0;
            end
            
            INIT: begin
                multiplicand <= {{8{a[7]}}, a};
                multiplier <= {{8{b[7]}}, b};
                p <= 0;
                rdy <= 0;
                counter <= 0;
            end
            
            COMPUTE: begin
                if (counter < 4) begin
                    // Get current Booth group (with overlap for sign extension)
                    booth_bits = {multiplier[1:0], (counter == 3) ? multiplier[1] : multiplier[2]};
                    
                    // Select partial product
                    case (booth_bits)
                        3'b000, 3'b111: partial_product <= 0;
                        3'b001, 3'b010: partial_product <= multiplicand;
                        3'b011:         partial_product <= pp_2A;
                        3'b100:         partial_product <= pp_neg2A;
                        3'b101, 3'b110: partial_product <= pp_negA;
                    endcase
                    
                    // Accumulate with proper shifting
                    p <= p + (partial_product << (counter * 2));
                    
                    // Arithmetic right shift multiplier
                    multiplier <= $signed(multiplier) >>> 2;
                    
                    counter <= counter + 1;
                end
            end
            
            DONE: begin
                rdy <= 1;
            end
        endcase
    end
    
    // Early termination detection
    wire early_done = (current_state == COMPUTE) && 
                     (counter > 0) && 
                     (multiplier == 0);
    
    always @(*) begin
        if (early_done)
            next_state = DONE;
    end

endmodule