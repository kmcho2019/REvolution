module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using enum for clarity
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // matched '1'
        S2   = 3'd2, // matched '10'
        S3   = 3'd3, // matched '100'
        S4   = 3'd4  // matched '1001'
    } state_t;

    state_t current_state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:    next_state = (data_in == 1'b0) ? S2 : S1;
            S2:    next_state = (data_in == 1'b0) ? S3 : S1;
            S3:    next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:    next_state = (data_in == 1'b1) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic registered and synchronous to clock
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule