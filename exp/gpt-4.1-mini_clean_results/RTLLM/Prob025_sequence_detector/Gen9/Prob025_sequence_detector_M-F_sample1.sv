module sequence_detector (
    input  wire clk,
    input  wire reset,         // Active-high synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using parameters
    localparam IDLE = 3'd0; // No bits matched
    localparam S1   = 3'd1; // matched '1'
    localparam S2   = 3'd2; // matched '10'
    localparam S3   = 3'd3; // matched '100'
    localparam S4   = 3'd4; // matched '1001' - detection state

    reg [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:     next_state = (data_in == 1'b0) ? S2 : S1;
            S2:     next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:     next_state = (data_in == 1'b1) ? S4 : S2;
            S4:     next_state = (data_in == 1'b1) ? S1 : S2; // Allow overlapping detection
            default:next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected is high only in S4 state
    always @(posedge clk) begin
        if (reset)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule