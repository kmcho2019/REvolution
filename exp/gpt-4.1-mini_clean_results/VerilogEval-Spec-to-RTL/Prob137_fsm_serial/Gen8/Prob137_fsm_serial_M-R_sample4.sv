module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)      // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and datapath
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default deassert done

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
                RECEIVE: begin
                    // Shift right, load new bit into MSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP: begin
                    bit_count <= 3'd0;
                    if (in == 1'b1)
                        done <= 1'b1;  // pulse done on correct stop bit
                    // else done remains 0 and FSM goes to WAIT_STOP
                end
                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule