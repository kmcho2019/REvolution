module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM encoding: 4 states
    // state bits:  [ERROR, STOP, DATA, IDLE]
    localparam IDLE_BIT  = 4'b0001;
    localparam DATA_BIT  = 4'b0010;
    localparam STOP_BIT  = 4'b0100;
    localparam ERROR_BIT = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic combinational, one-hot style
    always @(*) begin
        done = 1'b0; // default done low on combinational

        case (1'b1)
            state[0]: begin // IDLE state (0001)
                if (in == 1'b0)
                    next_state = DATA_BIT;
                else
                    next_state = IDLE_BIT;
            end
            state[1]: begin // DATA state (0010)
                if (bit_count == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BIT;
            end
            state[2]: begin // STOP state (0100)
                if (in == 1'b1)
                    next_state = IDLE_BIT;
                else
                    next_state = ERROR_BIT;
            end
            state[3]: begin // ERROR state (1000)
                if (in == 1'b1)
                    next_state = IDLE_BIT;
                else
                    next_state = ERROR_BIT;
            end
            default: next_state = IDLE_BIT;
        endcase
    end

    // Sequential logic: state register update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE_BIT;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // done pulse synchronous in STOP state if stop bit correct
            done <= (state[2] && (in == 1'b1));

            // Update bit_count only in DATA state
            if (state[1])
                bit_count <= bit_count + 1'b1;
            else
                bit_count <= 3'd0;

            // Shift register update only in DATA state
            if (state[1])
                shift_reg <= {shift_reg[6:0], in};
            else
                shift_reg <= 8'd0;
        end
    end

endmodule