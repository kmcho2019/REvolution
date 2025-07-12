module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        CALC,
        DONE
    } state_t;

    // Control signals
    state_t current_state, next_state;
    reg [4:0] bit_counter;
    reg [15:0] multiplicand;
    reg [31:0] product;
    reg [15:0] multiplier;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (bit_counter == 16) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'b0;
            multiplier <= 16'b0;
            product <= 32'b0;
            bit_counter <= 5'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= bin;
                    end
                end
                
                LOAD: begin
                    product <= 32'b0;
                    bit_counter <= 5'b0;
                end
                
                CALC: begin
                    if (multiplicand[bit_counter]) begin
                        product <= product + (multiplier << bit_counter);
                    end
                    bit_counter <= bit_counter + 1;
                end
                
                DONE: begin
                    yout <= product;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule