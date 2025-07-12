module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE   = 3'd0,
               S1     = 3'd1,  // matched '1'
               S2     = 3'd2,  // matched '10'
               S3     = 3'd3,  // matched '100'
               DETECT = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = data_in ? S1 : IDLE;
            S1:     next_state = data_in ? S1 : S2;
            S2:     next_state = data_in ? S1 : S3;
            S3:     next_state = data_in ? DETECT : IDLE;
            DETECT: next_state = data_in ? S1 : S2;  // allows overlapping detection
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted only in DETECT state
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == DETECT);
    end

endmodule