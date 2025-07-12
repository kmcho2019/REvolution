module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Simplified FSM states
    localparam IDLE     = 2'd0;
    localparam RECEIVE  = 2'd1;
    localparam STOP_WAIT= 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
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
                if (in == 1'b1) // valid stop bit
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT; // wait here until stop bit seen
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

            done <= 1'b0; // default no pulse

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                end

                STOP_WAIT: begin
                    bit_count <= 3'd0;
                    if (in == 1'b1) // stop bit correct, pulse done
                        done <= 1'b1;
                end
            endcase
        end
    end

endmodule