module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

    // Sequential logic: state, shift_reg, bit_count, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done is low, pulse set below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    // Shift right: insert new bit at LSB (bit 0), LSB-first serial input
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                    if (in == 1'b1)
                        done <= 1'b1;  // Pulse done on correct stop bit
                end

                WAIT_STOP: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
            endcase
        end
    end

endmodule