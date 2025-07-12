module width_8to16 (
    input           clk,
    input           rst_n,      // active low reset
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,        // Waiting for first byte
        WAIT_SECOND = 2'd1, // First byte stored, waiting for second
        OUTPUT = 2'd2       // Outputting concatenated data for one cycle
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;       // Store first byte
    reg [7:0] data_second;     // Store second byte to output next cycle

    // Sequential state and registers update
    always @(posedge clk) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            data_second<= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    if (valid_in) begin
                        data_second <= data_in;
                    end
                end

                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out  <= {data_lock, data_second};
                end

                default: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
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
                // After outputting once, go back to IDLE
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule