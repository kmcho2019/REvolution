module sequence_detector (
    input  wire clk,
    input  wire rst_n,       // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using typedef enum for clarity
    typedef enum reg [2:0] {
        IDLE = 3'd0,   // No bits matched yet
        S1   = 3'd1,   // Matched '1'
        S2   = 3'd2,   // Matched '10'
        S3   = 3'd3,   // Matched '100'
        S4   = 3'd4    // Matched '1001' - final detection state
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (data_in) ? S1 : IDLE;

            S1: 
                next_state = (~data_in) ? S2 : S1; // if '0' go to S2, else remain S1

            S2: 
                next_state = (~data_in) ? S3 : S1; // if '0' go to S3, else restart S1 due to overlap

            S3: 
                next_state = (data_in) ? S4 : IDLE; // if '1' detected, sequence complete else IDLE

            S4: 
                // After detection, check for overlap:
                // Since last bit is '1', can start again at S1 if input '1', else IDLE
                next_state = (data_in) ? S1 : IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic: state and output registers with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only when in final detection state S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule