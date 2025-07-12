module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoding of states
    localparam IDLE = 4'b0001; // no match yet
    localparam S1   = 4'b0010; // matched '1'
    localparam S2   = 4'b0100; // matched '10'
    localparam S3   = 4'b1000; // matched '100'

    reg [3:0] state, next_state;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // Default values
        next_state = IDLE;
        sequence_detected = 1'b0;

        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;  // matched first '1'
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;  // matched '10'
                else
                    next_state = S1;  // still matched '1' (overlapping)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;  // matched '100'
                else
                    next_state = S1;  // restart at '1' if input is '1'
            end
            S3: begin
                if (data_in == 1'b1) begin
                    sequence_detected = 1'b1; // matched '1001'
                    next_state = S1;  // allow overlapping sequences
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        endcase
    end

endmodule