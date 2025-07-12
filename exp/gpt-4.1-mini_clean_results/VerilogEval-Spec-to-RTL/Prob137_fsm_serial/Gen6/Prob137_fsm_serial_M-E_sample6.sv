module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM state encoding
    localparam IDLE          = 2'd0;
    localparam RECEIVING     = 2'd1;
    localparam WAIT_FOR_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [3:0] bit_index; // 0 to 8: 8 data bits counted

    // Next state and done combinational logic
    always @(*) begin
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                // Receive data bits 0 to 7
                if (bit_index == 4'd7)
                    next_state = WAIT_FOR_STOP;
                else
                    next_state = RECEIVING;
            end

            WAIT_FOR_STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;   // Valid stop bit, byte done
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait here until stop bit seen
                    next_state = WAIT_FOR_STOP;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and bit_index
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done;

            case (state)
                IDLE: begin
                    bit_index <= 4'd0;
                end

                RECEIVING: begin
                    // Increment bit count each clock during RECEIVING
                    bit_index <= bit_index + 1'b1;
                end

                WAIT_FOR_STOP: begin
                    bit_index <= 4'd0;
                end

                default: bit_index <= 4'd0;
            endcase
        end
    end

endmodule