module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE       = 2'b00, // waiting for initial 0
        WAIT_FOR_1 = 2'b01, // detected 0, wait for 1
        WAIT_FOR_0 = 2'b10  // detected 1, wait for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // Sequential logic for state and output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when we detect the last 0 in the pulse pattern
            if (state == WAIT_FOR_0 && data_in == 1'b0) begin
                data_out <= 1'b1;
            end else begin
                data_out <= 1'b0;
            end
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for data_in to be 0 to start pulse detection
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_1;
                else
                    next_state = IDLE;
            end
            WAIT_FOR_1: begin
                // Wait for 1
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_0;
                else // data_in == 0, keep waiting for 1
                    next_state = WAIT_FOR_1;
            end
            WAIT_FOR_0: begin
                // Wait for 0 to complete pulse
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_1; // pulse complete, return to wait for next pulse
                else
                    next_state = WAIT_FOR_0; // still waiting for 0
            end
            default: next_state = IDLE;
        endcase
    end

endmodule