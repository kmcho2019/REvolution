module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // Waiting for rising edge (data_in=1)
        HIGH = 2'b01,  // data_in=1 detected, waiting for falling edge
        LOW  = 2'b10   // data_in=0 detected after HIGH, pulse complete
    } state_t;

    state_t state, next_state;

    // FSM state transition logic
    always @(*) begin
        data_out = 1'b0;  // default output

        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (~data_in)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end

            LOW: begin
                // Pulse detected at transition LOW, output pulse here
                data_out = 1'b1;

                // Check for immediate next pulse start
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // FSM state update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;

            // data_out is combinationally assigned in the combinational always block,
            // but must be registered to meet output requirements:
            // To do this, move data_out assignment here:
            case(next_state)
                LOW: data_out <= 1'b1;
                default: data_out <= 1'b0;
            endcase
        end
    end

endmodule