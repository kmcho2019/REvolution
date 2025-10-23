module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for clarity
    localparam IDLE = 4'b0001;
    localparam S1   = 4'b0010;  // matched '1'
    localparam S2   = 4'b0100;  // matched '10'
    localparam S3   = 4'b1000;  // matched '100'

    reg [3:0] state, next_state;

    // Synchronous state update with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic (Mealy style)
    always @(*) begin
        // Default values
        next_state = IDLE;
        sequence_detected = 1'b0;

        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (!data_in)
                    next_state = IDLE;
                else
                    next_state = S3;
            end

            S3: begin
                if (data_in) begin
                    // Sequence 1001 detected at this input
                    sequence_detected = 1'b1;
                    // Overlap handling: since last bit '1' detected, next state is S1
                    next_state = S1;
                end else begin
                    next_state = S2;
                end
            end

            default: begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        endcase
    end

endmodule