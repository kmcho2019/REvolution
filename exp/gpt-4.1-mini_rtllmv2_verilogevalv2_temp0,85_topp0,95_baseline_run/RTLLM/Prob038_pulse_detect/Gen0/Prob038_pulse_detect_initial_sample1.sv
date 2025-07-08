module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0, // waiting for first 0
        S1   = 2'd1, // saw 0, waiting for 1
        S2   = 2'd2  // saw 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // State transition logic and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output is 1 only when completing the pulse (detect 0 in S2)
            data_out <= (state == S2 && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else if (data_in == 1'b0)
                    next_state = S1; // remain in S1 if still 0
                else
                    next_state = IDLE;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S1; // after pulse, go back to S1 (saw 0)
                else if (data_in == 1'b1)
                    next_state = S2; // still waiting for 0 to complete pulse
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule