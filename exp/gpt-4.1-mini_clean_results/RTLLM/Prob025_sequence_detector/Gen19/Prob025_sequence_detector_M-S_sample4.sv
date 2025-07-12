module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,  // Detected '1'
        S2   = 2'b10,  // Detected "10"
        S3   = 2'b11   // Detected "100"
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S3 : IDLE;
            S3:   next_state = data_in ? S1 : S2; // After "100", if data_in=1 → '1' detected (S1), else '0' detected (S2)
            default: next_state = IDLE;
        endcase
    end

    // Output combinational logic: sequence_detected asserted when in S3 and next input is '1' (completing "1001")
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && data_in;
    end

endmodule