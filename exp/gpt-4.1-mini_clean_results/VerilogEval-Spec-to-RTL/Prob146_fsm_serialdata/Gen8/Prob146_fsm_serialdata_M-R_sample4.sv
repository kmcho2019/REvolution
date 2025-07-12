module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // States
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP       = 2'd2,
        WAIT_STOP  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:       next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            data_shift <= 8'd0;
            bit_count <= 3'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default, pulse for one cycle on stop bit

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // Wait until line returns to idle (1)
                    // No data updates here
                end
            endcase
        end
    end

endmodule