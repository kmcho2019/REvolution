module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

parameter IDLE = 2'b00, DATA = 2'b01, STOP = 2'b10;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
    end
    else begin
        state <= next_state;
        case(next_state)
            DATA: begin
                data <= {data[6:0], in};
            end
            STOP: begin
                if (in) begin // Correct stop bit
                    out_byte <= data;
                    done <= 1;
                end
                else begin // Incorrect stop bit, stay in STOP
                    done <= 0;
                end
            end
            default: begin
                data <= 8'b0;
                done <= 0;
            end
        endcase
        bit_counter <= next_bit_counter;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (!in) begin // Start bit detected
                next_state = DATA;
                next_bit_counter = 3'b001;
            end
            else begin
                next_state = IDLE;
                next_bit_counter = 3'b000;
            end
        end
        DATA: begin
            if (bit_counter == 3'd7) begin // All data bits received
                next_state = STOP;
                next_bit_counter = 3'b000;
            end
            else begin
                next_state = DATA;
                next_bit_counter = bit_counter + 1;
            end
        end
        STOP: begin
            if (in) begin // Transition to IDLE after correct stop bit
                next_state = IDLE;
                next_bit_counter = 3'b000;
            end
            else begin // Wait for correct stop bit
                next_state = STOP;
                next_bit_counter = 3'b000;
            end
        end
        default: begin
            next_state = IDLE;
            next_bit_counter = 3'b000;
        end
    endcase
end

endmodule