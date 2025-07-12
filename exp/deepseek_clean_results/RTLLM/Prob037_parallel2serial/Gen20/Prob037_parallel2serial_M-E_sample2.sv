module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        BIT0,
        BIT1,
        BIT2
    } state_t;

    state_t current_state, next_state;
    reg [3:0] data_reg;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_reg <= 4'b0;
        end else begin
            current_state <= next_state;
            // Only load new data when entering BIT0 state
            if (next_state == BIT0) begin
                data_reg <= d;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = BIT0;
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = BIT0;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        valid_out = (current_state == IDLE);  // Valid one cycle before data
        case (current_state)
            IDLE:   dout = 1'b0;  // Don't care (valid_out is 0)
            BIT0:   dout = data_reg[3];
            BIT1:   dout = data_reg[2];
            BIT2:   dout = data_reg[1];
            default: dout = 1'b0;
        endcase
    end

endmodule