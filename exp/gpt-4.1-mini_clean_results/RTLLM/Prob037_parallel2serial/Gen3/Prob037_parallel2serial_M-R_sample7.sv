module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    // FSM states
    typedef enum logic [0:0] {
        LOAD  = 1'b0,
        SHIFT = 1'b1
    } state_t;

    reg [3:0] shift_reg;
    reg [1:0] bit_cnt;
    reg       curr_valid;
    state_t   state, next_state;

    // Output is the MSB of the shift register
    assign dout = shift_reg[3];

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= LOAD;
            shift_reg <= 4'b0;
            bit_cnt   <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                LOAD: begin
                    shift_reg <= d;       // Load input data
                    bit_cnt   <= 2'd0;    // Reset bit counter
                    valid_out <= 1'b1;    // Valid at first bit output (MSB)
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left by 1
                    bit_cnt   <= bit_cnt + 1'b1;
                    valid_out <= 1'b0;    // Valid only during LOAD state
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            LOAD:
                next_state = SHIFT;
            SHIFT:
                next_state = (bit_cnt == 2'd3) ? LOAD : SHIFT;
            default:
                next_state = LOAD;
        endcase
    end

endmodule