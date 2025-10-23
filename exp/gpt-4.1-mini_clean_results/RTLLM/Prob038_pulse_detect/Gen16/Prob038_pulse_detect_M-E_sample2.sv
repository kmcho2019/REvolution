module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_0 = 2'd0,   // Waiting for initial 0
        WAIT_1 = 2'd1,   // Detected 0, waiting for 1
        WAIT_0_END = 2'd2 // Detected 0->1, waiting for 0 to end pulse
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when pulse ends, otherwise 0
            data_out <= (state == WAIT_0_END && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_0: begin
                if (data_in == 1'b0)
                    next_state = WAIT_1;
                else
                    next_state = WAIT_0;
            end
            WAIT_1: begin
                if (data_in == 1'b1)
                    next_state = WAIT_0_END;
                else if (data_in == 1'b0)
                    next_state = WAIT_1; // stay until 1 arrives
                else
                    next_state = WAIT_0;
            end
            WAIT_0_END: begin
                if (data_in == 1'b0)
                    next_state = WAIT_1;  // Pulse ended, start detecting next
                else
                    next_state = WAIT_0_END; // wait for 0 to end pulse
            end
            default: next_state = WAIT_0;
        endcase
    end

endmodule