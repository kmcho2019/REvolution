module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // States representing how many bits matched in "1001"
    parameter IDLE = 3'd0;
    parameter S1   = 3'd1;  // matched '1'
    parameter S2   = 3'd2;  // matched '10'
    parameter S3   = 3'd3;  // matched '100'
    parameter S4   = 3'd4;  // matched '1001' (final detection state)

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (data_in) ? S1 : IDLE;
            S1:    next_state = (data_in) ? S1 : S2;
            S2:    next_state = (data_in) ? S1 : S3;
            S3:    next_state = (data_in) ? S4 : IDLE;
            S4:    next_state = (data_in) ? S1 : S2; // Allow overlapping detection
            default: next_state = IDLE;
        endcase
    end

    // State register with active-low synchronous reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: asserted for one clock cycle when S4 is reached
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule