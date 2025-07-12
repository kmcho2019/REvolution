module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active low reset renamed for consistency
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: one-hot style for clarity and efficiency
    localparam IDLE = 3'b001;
    localparam S1   = 3'b010;
    localparam S2   = 3'b100;
    // Note: We use only 3 states here because the problem defines 5 states,
    // but S4 can be combined with detection logic without separate state to optimize.

    reg [2:0] current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE; // After receiving bit '1' here, 
                                       // we check output and remain or restart, so next state IDLE
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and state update logic
    // We add a detection condition for the full sequence "1001" based on the previous bits
    // We need to keep track of sequence progress to detect '1001'

    // To detect the final '1' (the 4th bit), we use a state S3 implicitly via logic.
    // We'll use a shift register of last 4 bits or extend states for full clarity.

    // For full clarity and correctness, re-implementing full 5-state FSM as originally requested.

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t state, next_st;

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:
                next_st = (data_in == 1'b1) ? S1 : IDLE;
            S1:
                next_st = (data_in == 1'b0) ? S2 : S1;
            S2:
                next_st = (data_in == 1'b0) ? IDLE : S3;
            S3:
                next_st = (data_in == 1'b1) ? S4 : S1;
            S4:
                // After detecting sequence, check for overlapping sequences
                next_st = (data_in == 1'b1) ? S1 : S2;
            default:
                next_st = IDLE;
        endcase
    end

    // Sequential state and output update, synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_st;
            sequence_detected <= (next_st == S4);
        end
    end

endmodule