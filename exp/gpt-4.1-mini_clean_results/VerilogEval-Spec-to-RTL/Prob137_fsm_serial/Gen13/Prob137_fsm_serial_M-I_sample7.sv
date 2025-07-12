module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
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

    // Sequential logic: state, bit_count, done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // done pulse generated only if stop bit correct
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
                    // No change to bit_count to reduce toggling; wait until stop bit detected
                end
            endcase
        end
    end

endmodule