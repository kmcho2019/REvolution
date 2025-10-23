module multi_8bit(
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg ready
);

    // FSM states
    typedef enum {IDLE, COMPUTE, DONE} state_t;
    state_t current_state, next_state;

    // Internal registers
    reg [7:0] multiplier;
    reg [15:0] multiplicand;
    reg [2:0] bit_counter;

    // FSM control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? COMPUTE : IDLE;
            COMPUTE: next_state = (bit_counter == 3'd7) ? DONE : COMPUTE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                if (start) begin
                    multiplicand <= {8'b0, A};
                    multiplier <= B;
                    product <= 16'b0;
                    bit_counter <= 3'b0;
                    ready <= 1'b0;
                end
            end
            
            COMPUTE: begin
                if (multiplier[0]) begin
                    product <= product + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;
                bit_counter <= bit_counter + 1;
            end
            
            DONE: begin
                ready <= 1'b1;
            end
        endcase
    end

endmodule