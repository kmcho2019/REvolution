module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot state encoding
    localparam IDLE         = 4'b0001;
    localparam HIGH_DETECTED = 4'b0010;
    localparam LOW_WAIT     = 4'b0100;
    localparam PULSE_END    = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end
            HIGH_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = LOW_WAIT;
                else
                    next_state = HIGH_DETECTED;
            end
            LOW_WAIT: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    next_state = HIGH_DETECTED;
            end
            PULSE_END: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= (next_state == PULSE_END);
        end
    end

endmodule