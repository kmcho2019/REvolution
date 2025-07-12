module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states: IDLE=0, RECEIVE=1
    reg state, next_state;

    reg [3:0] bit_count;   // counts from 0 to 9 (start + 8 data + stop)
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        case (state)
            1'b0: // IDLE
                next_state = (in == 1'b0) ? 1'b1 : 1'b0; // start bit detected -> RECEIVE
            1'b1: // RECEIVE
                next_state = (bit_count == 4'd9) ? 1'b0 : 1'b1; // after 10 bits go back to IDLE
            default:
                next_state = 1'b0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= 1'b0;
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            if (state == 1'b0) begin // IDLE
                bit_count <= 4'd0;
                shift_reg <= 8'd0;
            end else if (state == 1'b1) begin // RECEIVE
                // Shift in data bits on bits 1..8 (bit_count 1 to 8)
                if (bit_count >= 4'd1 && bit_count <= 4'd8) begin
                    // Shift left by 1, insert 'in' at LSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                end

                bit_count <= bit_count + 1'b1;

                // On bit_count == 9 (stop bit), check and assert done if stop bit correct
                if (bit_count == 4'd9) begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end
            end
        end
    end

endmodule