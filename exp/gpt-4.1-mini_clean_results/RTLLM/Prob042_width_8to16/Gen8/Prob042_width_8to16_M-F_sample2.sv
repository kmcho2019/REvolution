module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;       // stores first 8-bit input
    reg [7:0] data_second;     // stores second 8-bit input

    // Sequential logic for state and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            data_second <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            valid_out <= 1'b0; // default de-assert

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;   // latch first input
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_second <= data_in; // latch second input
                    end
                end

                OUTPUT: begin
                    // Output registered data and valid_out one cycle after second input
                    data_out  <= {data_lock, data_second};
                    valid_out <= 1'b1;

                    // If new valid_in arrives in output cycle, treat as new first input
                    if (valid_in) begin
                        data_lock <= data_in;
                    end else begin
                        data_lock <= 8'd0;
                    end

                    // Clear second data after output
                    data_second <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT;
                else
                    next_state = WAIT_SECOND;
            end

            OUTPUT: begin
                // After output, if new input valid, go WAIT_SECOND, else IDLE
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule