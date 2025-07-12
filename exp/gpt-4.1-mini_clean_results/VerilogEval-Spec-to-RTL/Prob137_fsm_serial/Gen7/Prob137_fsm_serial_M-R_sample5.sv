module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2,
        ERROR   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] data_reg;
    reg [2:0] bit_count;

    // Next state logic and done combinational generation
    always @(*) begin
        // Default next state is hold current state
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1; // valid stop bit, byte received
                end else
                    next_state = ERROR;
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right: incoming LSB placed as MSB to capture LSB-first serial bits
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // done is assigned combinationally, no need to set here
                end

                ERROR: begin
                    // Wait for stop bit, no registers updated
                end
            endcase
        end
    end

endmodule