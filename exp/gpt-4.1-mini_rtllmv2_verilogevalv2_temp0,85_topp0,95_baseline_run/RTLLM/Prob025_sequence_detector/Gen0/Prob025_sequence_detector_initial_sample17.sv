module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparam for clarity
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] current_state, next_state;

    // State transition logic (combinational)
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
                    next_state = S1;  // If 1 again, stay in S1 (since sequence starts with 1)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // sequence is 10, next bit is 0 not matching third bit=0? Actually the third bit is 0, so if input 0, go to S3
                // Correction here: The sequence is 1 0 0 1, so third bit is 0
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // If 1, could be start of new sequence, so go to S1
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE; // default safe
            end
            S4: begin
                // Sequence detected, check for overlapping sequences:
                // The last bit is 1, so if next input is 1, stay in S1
                // else if next input is 0, go to S2 if it fits
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE; // else go to IDLE
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic (sequential)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4) ? 1'b1 : 1'b0;
        end
    end

endmodule