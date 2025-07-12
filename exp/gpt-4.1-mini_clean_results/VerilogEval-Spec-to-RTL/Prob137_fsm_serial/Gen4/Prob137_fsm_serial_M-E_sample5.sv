module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states (4 states)
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;      // Counts bits received (0 to 7)
    reg [7:0] data_reg;       // Shift register: shift right, insert new bit at MSB

    // Sequential logic: state, data_reg, bit_count, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, pulse only in STOP if stop bit valid
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right data_reg by 1, insert 'in' bit at MSB
                    // This correctly assembles LSB-first bits as they come
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // On valid stop bit (in == 1), pulse done
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    // Hold until stop bit detected (in == 1)
                end

                default: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next_state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (in == 0) to begin reception
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to STOP to check stop bit
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                // If stop bit valid, go back to IDLE and pulse done
                // Otherwise move to WAIT_STOP and wait for valid stop bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait here until stop bit 1 detected to return to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule