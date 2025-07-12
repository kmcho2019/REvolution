module sequence_detector (
    input  wire clk,
    input  wire reset_n,      // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // Binary state encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001, // matched '1'
        S2   = 3'b010, // matched '10'
        S3   = 3'b011, // matched '100'
        S4   = 3'b100  // matched '1001' (final)
    } state_t;

    state_t state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case(state)
            IDLE: 
                next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:
                next_state = (data_in == 1'b0) ? S2 : S1; // stay in S1 if input '1' (overlap)
            S2:
                next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:
                next_state = (data_in == 1'b1) ? S4 : S2; // '10' prefix overlap on '0'
            S4:
                next_state = (data_in == 1'b1) ? S1 : S2; // overlap restart
            default:
                next_state = IDLE;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output asserted when FSM is in final state (Moore output)
    assign sequence_detected = (state == S4);

endmodule