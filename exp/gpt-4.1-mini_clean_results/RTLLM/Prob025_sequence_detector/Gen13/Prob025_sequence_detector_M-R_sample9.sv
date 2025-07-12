module sequence_detector (
    input  wire clk,
    input  wire reset_n,      // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // Binary encoding of states (3 bits needed for 5 states)
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1; // matched '1'
    localparam S2   = 3'd2; // matched '10'
    localparam S3   = 3'd3; // matched '100'
    localparam S4   = 3'd4; // matched '1001' (final matched state)

    reg [2:0] state, next_state;

    // Next state logic as combinational assigns
    wire data = data_in;

    // Default next_state is IDLE
    // We define next_state based on current state and data_in
    always @(*) begin
        case (state)
            IDLE:   next_state = (data == 1'b1) ? S1 : IDLE;
            S1:     next_state = (data == 1'b0) ? S2 : S1; // stay in S1 if input '1' again (overlap)
            S2:     next_state = (data == 1'b0) ? S3 : IDLE;
            S3:     next_state = (data == 1'b1) ? S4 : S2; // overlapping detection with fallback to S2
            S4:     next_state = (data == 1'b1) ? S1 : S2; // allow overlapping detection
            default:next_state = IDLE;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic as assign statement (combinational)
    assign sequence_detected = (state == S4);

endmodule