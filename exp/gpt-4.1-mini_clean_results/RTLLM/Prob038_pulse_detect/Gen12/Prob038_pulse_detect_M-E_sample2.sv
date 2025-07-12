module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        GOT_ZERO  = 2'b01,
        GOT_ONE   = 2'b10,
        PULSE_END = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = GOT_ZERO;
                else
                    next_state = IDLE;
            end
            GOT_ZERO: begin
                if (data_in == 1'b1)
                    next_state = GOT_ONE;
                else if (data_in == 1'b0)
                    next_state = GOT_ZERO; // stay waiting for 1
                else
                    next_state = IDLE; // fallback
            end
            GOT_ONE: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else if (data_in == 1'b1)
                    next_state = GOT_ONE; // still waiting for trailing 0
                else
                    next_state = IDLE;
            end
            PULSE_END: begin
                // After signaling pulse, move to IDLE and restart detection
                if (data_in == 1'b0)
                    next_state = GOT_ZERO; 
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only at the pulse end state
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

endmodule