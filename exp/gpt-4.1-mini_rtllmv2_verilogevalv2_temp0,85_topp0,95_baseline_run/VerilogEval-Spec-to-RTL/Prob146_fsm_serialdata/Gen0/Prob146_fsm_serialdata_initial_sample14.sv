module TopModule(
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 3'b000;
    localparam START     = 3'b001;
    localparam DATA      = 3'b010;
    localparam STOP      = 3'b011;
    localparam WAIT_STOP = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;         // Counts 0 to 7 for data bits
    reg [7:0] data_reg;        // Shift register for data bits

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done low

            case (state)
                IDLE: begin
                    if (in == 1'b0) // start bit detected
                        bit_cnt <= 3'd0;
                end

                START: begin
                    // No action; transition handled below
                end

                DATA: begin
                    // Shift in data bit at LSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Stop bit correct, output data and done
                        out_byte <= data_reg;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // No change to data_reg or bit_cnt
                    // Wait for stop bit to be 1 to resync
                end

                default: ;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Move immediately to DATA on next clock
                next_state = DATA;
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule