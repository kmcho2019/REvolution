module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for control FSM
    typedef enum logic [1:0] {
        IDLE,
        CALCULATE,
        DONE
    } state_t;
    
    reg [1:0] state, next_state;
    reg [2:0] counter;  // 3-bit counter (0-4)
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;
    
    // Precompute all possible partial products
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = {multiplicand[14:0], 1'b0};
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -pp_2A;
    
    // Booth encoding (registered for better timing)
    reg [15:0] partial_product;
    always @(posedge clk) begin
        if (reset) begin
            partial_product <= 16'b0;
        end else if (state == CALCULATE) begin
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: partial_product <= pp_0;
                3'b001, 3'b010: partial_product <= pp_A;
                3'b011:         partial_product <= pp_2A;
                3'b100:         partial_product <= pp_neg2A;
                3'b101, 3'b110: partial_product <= pp_negA;
                default:       partial_product <= pp_0;
            endcase
        end
    end
    
    // Accumulate partial products with proper shifting
    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
        end else if (state == CALCULATE) begin
            p <= p + (partial_product << (counter * 2));
        end
    end
    
    // State machine and control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            counter <= 3'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            prev_lsb <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    p <= 16'b0;
                    rdy <= 1'b0;
                    counter <= 3'b0;
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    prev_lsb <= 1'b0;
                end
                
                CALCULATE: begin
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    counter <= counter + 1;
                end
                
                DONE: begin
                    rdy <= 1'b1;
                end
            endcase
        end
    end
    
    // Next state logic
    always @* begin
        case (state)
            IDLE:     next_state = CALCULATE;
            CALCULATE: next_state = (counter == 3'd3) ? DONE : CALCULATE;
            DONE:     next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

endmodule