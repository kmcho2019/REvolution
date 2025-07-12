module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // Waiting for initial 0
        HIGH = 2'b01,  // Saw 0->1 edge
        DONE = 2'b10   // Pulse end detected (0 after 1)
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = DONE;
                else
                    next_state = HIGH;
            end
            DONE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted for one cycle when entering DONE state
            data_out <= (next_state == DONE) ? 1'b1 : 1'b0;
        end
    end

endmodule