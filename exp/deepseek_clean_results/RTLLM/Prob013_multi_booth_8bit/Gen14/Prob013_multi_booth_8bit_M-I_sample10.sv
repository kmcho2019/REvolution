module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding (Gray coded for reduced switching)
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        CALC1 = 2'b01,
        CALC2 = 2'b11,
        DONE  = 2'b10
    } state_t;
    
    reg [1:0] state, next_state;
    
    // Data registers (optimized sizes)
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [1:0] counter;
    reg [15:0] accum;
    
    // Pipeline registers
    reg [15:0] booth_result_stage1;
    reg [15:0] multiplicand_shifted;
    reg [1:0] booth_sel;
    
    // Shared arithmetic unit
    wire [15:0] adder_in1 = (booth_sel[1]) ? {7'b0, multiplicand, 1'b0} :  // x2
                           {8'b0, multiplicand};                          // x1
    wire [15:0] adder_in2 = accum;
    wire [15:0] adder_out = booth_sel[0] ? adder_in2 - adder_in1 : adder_in2 + adder_in1;
    
    // Clock gating signals
    wire calc_active = (state == CALC1) || (state == CALC2);
    wire clk_gated = clk & calc_active;
    
    // Next state logic
    always_comb begin
        next_state = state;
        rdy = 1'b0;
        
        case (state)
            IDLE: if (!reset) next_state = CALC1;
            CALC1: next_state = CALC2;
            CALC2: begin
                if (counter == 2'b11) 
                    next_state = DONE;
                else 
                    next_state = CALC1;
            end
            DONE: begin
                rdy = 1'b1;
                if (reset) next_state = IDLE;
            end
        endcase
    end
    
    // Stage 1: Booth encoding and operand preparation
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            booth_result_stage1 <= 16'b0;
            multiplicand_shifted <= 16'b0;
            booth_sel <= 2'b0;
        end else if (state == CALC1) begin
            // Booth encoding
            case ({multiplier[1:0], prev_lsb})
                3'b001, 3'b010: booth_sel <= 2'b00; // +1x
                3'b011:          booth_sel <= 2'b01; // +2x
                3'b100:          booth_sel <= 2'b11; // -2x
                3'b101, 3'b110:  booth_sel <= 2'b10; // -1x
                default:         booth_sel <= 2'b00; // 0
            endcase
            
            multiplicand_shifted <= {7'b0, multiplicand, 1'b0}; // x2 shifted
        end
    end
    
    // Stage 2: Arithmetic operation and register updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= 9'b0;
            multiplier <= 8'b0;
            prev_lsb <= 1'b0;
            counter <= 2'b0;
            accum <= 16'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    multiplicand <= {a[7], a};
                    multiplier <= b;
                    accum <= 16'b0;
                    counter <= 2'b0;
                    prev_lsb <= 1'b0;
                end
                
                CALC2: begin
                    accum <= adder_out;
                    multiplicand <= multiplicand[7:0] << 2;
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    counter <= counter + 1;
                    
                    if (next_state == DONE)
                        p <= adder_out;
                end
            endcase
        end
    end

endmodule