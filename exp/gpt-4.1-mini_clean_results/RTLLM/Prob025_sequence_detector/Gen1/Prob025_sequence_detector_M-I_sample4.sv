module sequence_detector(
    input  wire clk,
    input  wire reset,        // active-high synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparams
    localparam IDLE = 3'd0,
               S1   = 3'd1, // matched '1'
               S2   = 3'd2, // matched '10'
               S3   = 3'd3, // matched '100'
               S4   = 3'd4; // matched '1001'

    reg [2:0] current_state, next_state;

    // Next state logic combinational
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
                    next_state = S1; // stay in S1 if input is 1 (handles overlapping)
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // Sequence detected, allow overlapping by moving to S1 if input is 1
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and output logic, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // Assert sequence_detected for one cycle when entering S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule