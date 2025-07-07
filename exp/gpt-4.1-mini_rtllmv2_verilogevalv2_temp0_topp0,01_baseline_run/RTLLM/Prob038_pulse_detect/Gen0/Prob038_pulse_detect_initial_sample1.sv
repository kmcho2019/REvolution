module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        S_WAIT_0 = 2'd0,  // Waiting for initial 0
        S_WAIT_1 = 2'd1,  // Detected 0, waiting for 1
        S_WAIT_0_END = 2'd2 // Detected 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_WAIT_0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when pulse ends (on transition to S_WAIT_0 after S_WAIT_0_END)
            if (state == S_WAIT_0_END && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_WAIT_0: begin
                if (data_in == 1'b0)
                    next_state = S_WAIT_1; // got first 0, wait for 1
                else
                    next_state = S_WAIT_0; // stay waiting for 0
            end
            S_WAIT_1: begin
                if (data_in == 1'b1)
                    next_state = S_WAIT_0_END; // got 1, wait for 0 to complete pulse
                else if (data_in == 1'b0)
                    next_state = S_WAIT_1; // still 0, keep waiting for 1
                else
                    next_state = S_WAIT_0; // fallback
            end
            S_WAIT_0_END: begin
                if (data_in == 1'b0)
                    next_state = S_WAIT_1; // pulse ended, start detecting next pulse
                else
                    next_state = S_WAIT_0_END; // still 1, wait for 0
            end
            default: next_state = S_WAIT_0;
        endcase
    end

endmodule