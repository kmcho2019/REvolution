module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // Define states
    typedef enum reg [1:0] {
        IDLE = 2'd0,  // Waiting for rising edge
        HIGH = 2'd1,  // data_in is 1, waiting for falling edge
        DONE = 2'd2   // Pulse detected
    } state_t;

    state_t state, next_state;

    // Next state logic and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output 1 only when going to DONE state (pulse detected)
            data_out <= (state == HIGH && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = HIGH;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule