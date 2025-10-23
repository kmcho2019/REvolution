module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state combinational logic (one-hot)
    always @(*) begin
        next_state = 4'b0000;
        case(1'b1) // synthesis parallel_case full_case
            state[0]: begin // IDLE
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            state[1]: begin // RECEIVE
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            state[2]: begin // CHECK_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            state[3]: begin // WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counter, shift register
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            // Clear counters and shift_reg only in IDLE or WAIT_STOP to reduce toggling
            if (next_state[0] || next_state[3]) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end else if (state[1]) begin
                // Update shift register and bit_count only in RECEIVE state
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end else if (state[2]) begin
                // bit_count cleared when returning to IDLE in next cycle
                // no updates to shift_reg needed here
            end
        end
    end

    // Done is a one-cycle pulse, asserted only on valid stop bit detection (CHECK_STOP state + in==1)
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule