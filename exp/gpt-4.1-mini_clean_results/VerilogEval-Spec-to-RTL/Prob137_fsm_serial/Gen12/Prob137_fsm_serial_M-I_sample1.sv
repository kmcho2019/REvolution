module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding: 2-bit encoding for 3 states
    // IDLE: waiting for start bit (0)
    // RECEIVE: receiving 8 data bits
    // STOP_WAIT: verifying stop bit or waiting for valid stop bit if framing error
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP_WAIT = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for 8 data bits

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)        // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                if (in == 1'b1)        // valid stop bit
                    next_state = IDLE;
                else                   // framing error: stay here until stop bit detected
                    next_state = STOP_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1 && state == STOP_WAIT && next_state == IDLE) 
                        done <= 1'b1;  // pulse done one cycle on valid stop bit
                    if (next_state == IDLE)
                        bit_count <= 3'd0; // reset counter when restarting byte reception
                end

                default: ;
            endcase
        end
    end

endmodule