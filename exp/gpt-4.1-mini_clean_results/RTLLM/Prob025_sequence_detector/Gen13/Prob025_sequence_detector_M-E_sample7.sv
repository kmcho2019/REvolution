module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded states representing matched bits count:
    // 0: IDLE - no bits matched
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001' - final detection state (transient)
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t state, next_state;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic based on current state and input bit
    always @(*) begin
        case(state)
            IDLE: 
                next_state = data_in ? S1 : IDLE;           // Wait for first '1'
            S1:
                next_state = data_in ? S1 : S2;             // Expect '0' next
            S2:
                next_state = data_in ? S1 : S3;             // Expect '0' next
            S3:
                next_state = data_in ? S4 : IDLE;           // Expect final '1'
            S4:
                // Output will assert this cycle, then move depending on input to support overlapping sequences
                next_state = data_in ? S1 : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected for one clock cycle when entering S4
    // Because output is Moore, it depends on current state only
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule