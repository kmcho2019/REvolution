module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Oversampling registers
    reg [3:0] sample_buffer;
    wire majority_bit = (sample_buffer[3:2] == 2'b00) ? 1'b0 : 
                       (sample_buffer[3:2] == 2'b11) ? 1'b1 : 
                       sample_buffer[1];

    // State machine
    localparam IDLE      = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam VALIDATE  = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] bit_counter;
    reg [7:0] data_buffer;
    reg [2:0] sample_counter;
    reg timeout;

    // Oversampling logic
    always @(posedge clk) begin
        if (reset) begin
            sample_buffer <= 4'b1111;
            sample_counter <= 0;
        end else begin
            sample_buffer <= {sample_buffer[2:0], in};
            sample_counter <= (sample_counter == 3) ? 0 : sample_counter + 1;
        end
    end

    // Timeout counter
    always @(posedge clk) begin
        if (reset || state == IDLE)
            timeout <= 0;
        else if (sample_counter == 3)
            timeout <= timeout + 1;
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            data_buffer <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case (state)
                IDLE: begin
                    bit_counter <= 0;
                    if (majority_bit == 0 && sample_counter == 3)
                        data_buffer <= 0;
                end

                RECEIVING: begin
                    if (sample_counter == 3) begin
                        if (bit_counter < 8) begin
                            data_buffer <= {majority_bit, data_buffer[7:1]};
                            bit_counter <= bit_counter + 1;
                        end
                    end
                end

                VALIDATE: begin
                    if (majority_bit == 1) begin
                        out_byte <= data_buffer;
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (majority_bit == 0 && sample_counter == 3) ? RECEIVING : IDLE;
            RECEIVING: begin
                if (timeout > 12)
                    next_state = IDLE;
                else if (bit_counter == 8 && sample_counter == 3)
                    next_state = VALIDATE;
                else
                    next_state = RECEIVING;
            end
            VALIDATE: next_state = (majority_bit == 1) ? IDLE : VALIDATE;
            default: next_state = IDLE;
        endcase
    end

endmodule