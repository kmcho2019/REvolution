module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states: IDLE, RECEIVE, STOP_CHECK (combines checking and waiting for stop bit)
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;  // start bit detected

            RECEIVE:
                next_state = (bit_count == 3'd7) ? STOP_CHECK : RECEIVE;

            STOP_CHECK:
                next_state = (in == 1'b1) ? IDLE : STOP_CHECK; // wait for valid stop bit

            default:
                next_state = IDLE;
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
            done  <= 1'b0; // default no done

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in bits LSB first: insert new bit at LSB, shift right
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1)
                        done <= 1'b1; // pulse done on correct stop bit
                    else begin
                        // framing error: wait here until stop bit detected, do not reset bit_count or shift_reg
                    end
                end
            endcase
        end
    end

endmodule