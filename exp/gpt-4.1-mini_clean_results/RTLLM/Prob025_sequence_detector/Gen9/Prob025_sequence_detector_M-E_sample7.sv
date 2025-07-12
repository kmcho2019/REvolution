module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // asynchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for clarity and simpler transition logic
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,  // matched '1'
               S2   = 5'b00100,  // matched "10"
               S3   = 5'b01000,  // matched "100"
               S4   = 5'b10000;  // matched "1001"

    reg [4:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic based on current state and data_in
    always @(*) begin
        // Default next_state is IDLE to avoid latches
        next_state = IDLE;
        case (state)
            IDLE: 
                next_state = data_in ? S1 : IDLE;

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    // If input is 1, remain in S1 since sequence starts with '1'
                    next_state = S1;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    // On input '1', restart detecting from S1
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    // On '0', sequence breaks, back to IDLE
                    next_state = IDLE;
            end

            S4: begin
                // After detection, check input to handle overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S2; // input '0' could start "10"
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: Assert sequence_detected high only when in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule