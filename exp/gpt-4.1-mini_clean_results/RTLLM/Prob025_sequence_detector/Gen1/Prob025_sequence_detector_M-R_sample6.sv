module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State declarations using one-hot encoding for clarity
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010;
    localparam S2   = 5'b00100;
    localparam S3   = 5'b01000;
    localparam S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State transition synchronous process with active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic combinational process
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        sequence_detected = 1'b0;

        case (state)
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
                    next_state = S3;
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = S2; // allow overlapping sequences
                else
                    next_state = IDLE;
            end

            S4: begin
                sequence_detected = 1'b1;  // Output asserted on detection state

                // Move to next state for overlapping detection
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        endcase
    end

endmodule