module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001' (output)
    } state_t;

    state_t state, next_state;

    // Function to compute next state based on current state and input
    function state_t f_next_state(input state_t cur_state, input bit in_bit);
        begin
            case (cur_state)
                IDLE:
                    f_next_state = in_bit ? S1 : IDLE;
                S1:
                    f_next_state = (in_bit == 1'b0) ? S2 : S1;
                S2:
                    f_next_state = (in_bit == 1'b0) ? IDLE : S3;
                S3:
                    f_next_state = (in_bit == 1'b1) ? S4 : S2;
                S4:
                    f_next_state = in_bit ? S1 : IDLE;
                default:
                    f_next_state = IDLE;
            endcase
        end
    endfunction

    // Sequential block: synchronous reset, state and output update
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

    // Combinational next state calculation
    always @(*) begin
        next_state = f_next_state(state, data_in);
    end

endmodule