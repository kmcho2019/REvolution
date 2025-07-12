module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    // State definitions
    typedef enum reg [0:0] {LOAD = 1'b0, SHIFT = 1'b1} state_t;
    state_t state, next_state;

    reg [3:0] shift_reg;
    reg [1:0] bit_cnt, next_bit_cnt;

    assign dout = shift_reg[3];

    // Next state logic
    always @(*) begin
        case(state)
            LOAD: begin
                next_state = SHIFT;
                next_bit_cnt = 2'd0;
            end
            SHIFT: begin
                if (bit_cnt == 2'd3) begin
                    next_state = LOAD;
                    next_bit_cnt = 2'd0;
                end else begin
                    next_state = SHIFT;
                    next_bit_cnt = bit_cnt + 1;
                end
            end
            default: begin
                next_state = LOAD;
                next_bit_cnt = 2'd0;
            end
        endcase
    end

    // Output logic and shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= LOAD;
            bit_cnt   <= 2'd0;
            shift_reg <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            state   <= next_state;
            bit_cnt <= next_bit_cnt;

            case (state)
                LOAD: begin
                    shift_reg <= d;      // Load parallel input
                    valid_out <= 1'b1;   // Valid output first cycle
                end
                SHIFT: begin
                    // Shift left by one bit, MSB discarded, LSB zero-filled
                    shift_reg <= {shift_reg[2:0], 1'b0};
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

endmodule