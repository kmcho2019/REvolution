module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for 5 states:
    // IDLE = 5'b00001
    // S1   = 5'b00010
    // S2   = 5'b00100
    // S3   = 5'b01000
    // S4   = 5'b10000
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next-state combinational logic (one-hot FSM)
    always @(*) begin
        // Default hold state
        next_state = IDLE;
        case (1'b1)  // Priority encoding style for one-hot
            state[0]: begin // IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            state[1]: begin // S1
                if (data_in)
                    next_state = S1;
                else
                    next_state = S2;
            end
            state[2]: begin // S2
                if (data_in)
                    next_state = S1;
                else
                    next_state = S3;
            end
            state[3]: begin // S3
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            state[4]: begin // S4 (sequence detected)
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Registered output (Moore FSM)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule