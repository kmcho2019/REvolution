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
        STATE_B2,
        STATE_B1,
        STATE_LSB
    } state_t;

    state_t current_state, next_state;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_MSB;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Load new data when transitioning from LSB to MSB
            if (current_state == STATE_LSB)
                data_reg <= d;
            
            // Output logic based on current state
            case (current_state)
                STATE_MSB: begin
                    dout <= data_reg[3];
                    valid_out <= 1'b1;
                end
                STATE_B2: begin
                    dout <= data_reg[2];
                    valid_out <= 1'b0;
                end
                STATE_B1: begin
                    dout <= data_reg[1];
                    valid_out <= 1'b0;
                end
                STATE_LSB: begin
                    dout <= data_reg[0];
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            STATE_MSB: next_state = STATE_B2;
            STATE_B2: next_state = STATE_B1;
            STATE_B1: next_state = STATE_LSB;
            STATE_LSB: next_state = STATE_MSB;
            default: next_state = STATE_MSB;
        endcase
    end

endmodule