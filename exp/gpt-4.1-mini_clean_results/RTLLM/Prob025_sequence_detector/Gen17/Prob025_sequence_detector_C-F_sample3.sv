module sequence_detector (
    input  wire clk,
    input  wire rst_n,          // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded states (3 bits)
    typedef enum reg [2:0] {
        IDLE = 3'd0,   // waiting for '1'
        S1   = 3'd1,   // matched '1'
        S2   = 3'd2,   // matched '10'
        S3   = 3'd3,   // matched '100'
        S4   = 3'd4    // matched '1001' - final detection
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;

            S1:   next_state = (~data_in) ? S2 : S1;

            S2:   next_state = (~data_in) ? S3 : S1; // if bit=1 here, restart from S1 (overlap)

            S3:   next_state = data_in ? S4 : IDLE;

            S4:   next_state = data_in ? S1 : IDLE;

            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore style output: asserted when in state S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule