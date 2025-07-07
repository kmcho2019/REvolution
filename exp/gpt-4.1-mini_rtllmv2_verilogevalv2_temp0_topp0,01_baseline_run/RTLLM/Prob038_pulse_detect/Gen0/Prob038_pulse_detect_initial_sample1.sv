module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00, // waiting for data_in=0
        S1    = 2'b01, // detected data_in=0, waiting for data_in=1
        S2    = 2'b10  // detected data_in=1, waiting for data_in=0 to complete pulse
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when pulse completes (on transition from S2 to IDLE)
            if (state == S2 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
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
                    next_state = S1; // stay in S1 if still 0
                else
                    next_state = IDLE;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // pulse complete
                else if (data_in == 1'b1)
                    next_state = S2; // stay in S2 if still 1
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule