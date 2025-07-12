module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        HIGH_DETECTED = 2'b01,
        LOW_DETECTED  = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // data_out is asserted only when the pulse ends (0->1->0 detected)
            // This corresponds to the cycle when we transition into IDLE after LOW_DETECTED
            // or directly when in LOW_DETECTED if we define it like that.
            // Here, we assert data_out only one cycle at pulse completion
            if (state == LOW_DETECTED && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end

            HIGH_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = LOW_DETECTED;
                else
                    next_state = HIGH_DETECTED;
            end

            LOW_DETECTED: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule