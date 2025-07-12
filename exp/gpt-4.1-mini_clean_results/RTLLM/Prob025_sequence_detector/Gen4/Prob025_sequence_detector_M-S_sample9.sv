module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    parameter IDLE = 3'd0,
              S1   = 3'd1,  // matched '1'
              S2   = 3'd2,  // matched '10'
              S3   = 3'd3,  // matched '100'
              S4   = 3'd4;  // matched '1001'

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
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S3 : IDLE;
            S3:   next_state = data_in ? S4 : S2;
            S4:   next_state = data_in ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        sequence_detected = (state == S4);
    end

endmodule