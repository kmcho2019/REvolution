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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    data_reg <= d;
                    dout <= d[3];  // MSB
                    valid_out <= 1'b1;
                end
                BIT0: begin
                    dout <= data_reg[2];
                    valid_out <= 1'b0;
                end
                BIT1: begin
                    dout <= data_reg[1];
                    valid_out <= 1'b0;
                end
                BIT2: begin
                    dout <= data_reg[0];  // LSB
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: next_state = BIT0;
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule