module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;     // count 0 to 7 data bits
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;

            RECEIVE:
                if (bit_count == 3'd7)
                    next_state = WAIT_STOP; // after 8 data bits, check stop bit next cycle
                else
                    next_state = RECEIVE;

            WAIT_STOP:
                if (in == 1'b1) // valid stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift right, LSB first input on MSB side
                    bit_count <= bit_count + 1'b1;
                end

                WAIT_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                    else begin
                        // stay here until stop bit received, reset counters
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end
            endcase
        end
    end

endmodule