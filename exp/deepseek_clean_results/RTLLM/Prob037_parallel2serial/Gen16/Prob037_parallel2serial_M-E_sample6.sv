module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // FSM states
    typedef enum logic [1:0] {
        STATE_MSB,
        STATE_BIT2,
        STATE_BIT1,
        STATE_LSB
    } state_t;

    state_t current_state, next_state;
    reg [3:0] data_reg;

    // State transition and data handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_MSB;
            data_reg <= 4'b0;
        end else begin
            current_state <= next_state;
            
            // Load new data when returning to MSB state
            if (current_state == STATE_LSB) begin
                data_reg <= d;
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            STATE_MSB:   next_state = STATE_BIT2;
            STATE_BIT2:  next_state = STATE_BIT1;
            STATE_BIT1:  next_state = STATE_LSB;
            STATE_LSB:  next_state = STATE_MSB;
            default:    next_state = STATE_MSB;
        endcase
    end

    // Output logic
    always_comb begin
        valid_out = (current_state == STATE_MSB);
        
        case (current_state)
            STATE_MSB:   dout = data_reg[3];
            STATE_BIT2:  dout = data_reg[2];
            STATE_BIT1:  dout = data_reg[1];
            STATE_LSB:   dout = data_reg[0];
            default:     dout = 1'b0;
        endcase
    end

endmodule