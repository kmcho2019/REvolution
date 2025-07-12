module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM state encoding (binary)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // default deassert done

            case(state)
                IDLE: begin
                    // Reset counters and shift register only here to reduce toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;

                    if (in == 1'b0)
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left and insert new bit at LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done  <= 1'b1;  // valid stop bit received, signal done
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, enter wait state to resync
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                    // else stay in WAIT_STOP until stop bit seen
                end

                default: begin
                    // Defensive coding: reset state on undefined condition
                    state <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule