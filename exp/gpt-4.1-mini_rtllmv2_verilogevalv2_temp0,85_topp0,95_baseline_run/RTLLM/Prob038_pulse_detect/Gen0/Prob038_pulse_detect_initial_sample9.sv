module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        WAIT_FOR_HIGH = 2'b01,
        WAIT_FOR_LOW = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next_state = state;
        data_out = 1'b0;

        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_FOR_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH; // stay here if still 0
                else
                    next_state = IDLE;
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0) begin
                    data_out = 1'b1; // pulse detected at this cycle
                    next_state = WAIT_FOR_HIGH; // next pulse can start immediately
                end else if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW; // wait for 0
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out assigned combinationally, so no need to assign here
            // but data_out is registered output, so assign here:
            // We capture data_out from combinational block
            data_out <= data_out;
        end
    end

endmodule