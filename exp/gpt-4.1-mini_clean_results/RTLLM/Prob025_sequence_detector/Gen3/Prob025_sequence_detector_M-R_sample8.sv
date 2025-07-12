module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding for clarity
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;
    reg sequence_detected_reg;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic combinational block
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        sequence_detected_reg = 1'b0;

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
                    next_state = S1;  // Remain in S1 if input still '1' (handles overlapping)
            end
            S2: begin
                if (!data_in)
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in) begin
                    next_state = S4;
                    sequence_detected_reg = 1'b1; // Output asserted on detection
                end else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, check input to handle overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
                // sequence_detected_reg is asserted only for one cycle in S3->S4 transition
            end
            default: begin
                next_state = IDLE;
                sequence_detected_reg = 1'b0;
            end
        endcase
    end

    assign sequence_detected = sequence_detected_reg;

endmodule