module pulse_detect (
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // waiting for first 0
        RISE = 2'b01,  // detected rising edge 0->1
        FALL = 2'b10   // detected falling edge 1->0 (pulse end)
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        data_out = 1'b0;  // default output
        case (state)
            IDLE: begin
                if (data_in == 1'b0)       next_state = RISE;   // Wait for 0 then next is 1
                else                      next_state = IDLE;   // still 0 expected, if data_in=1 no start
            end
            RISE: begin
                if (data_in == 1'b1)       next_state = FALL;   // got 1 after 0
                else                      next_state = IDLE;   // didn't get 1, restart
            end
            FALL: begin
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                end else begin
                    next_state = IDLE; // pattern ended, go back to IDLE for next pulse
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // State update and output logic (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output data_out=1 at the end of the pulse detection: when we enter FALL state with data_in=0
            // Actually the pulse ends when data_in transitions back to 0 after being 1
            if (state == RISE && data_in == 1'b0)
                data_out <= 1'b1; // pulse ends at third cycle
            else if (state == FALL)
                data_out <= 1'b1; // also output 1 at FALL state for pulse end
            else
                data_out <= 1'b0;
        end
    end

endmodule