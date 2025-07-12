module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] shift_reg;    // shift register for data bits

    // Local signals for input conditions
    wire start_bit_detected = (in == 1'b0);
    wire stop_bit_detected  = (in == 1'b1);

    // Combinational logic for next state and done
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (start_bit_detected)
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
                if (stop_bit_detected) begin
                    done = 1'b1;  // valid byte received
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (stop_bit_detected)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic with clock enable gating and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done; // output assigned in combinational logic

            // Update shift register and bit count only in RECEIVE state
            if (state == RECEIVE) begin
                // Shift in LSB first: shift left, new bit into LSB
                shift_reg <= {shift_reg[6:0], in};
                bit_count <= bit_count + 1'b1;
            end else if ((state != RECEIVE) && (next_state == IDLE)) begin
                // Clear bit_count and shift_reg on transition to IDLE from other states
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
            // No updates to shift_reg or bit_count in other states to minimize toggling
        end
    end

endmodule