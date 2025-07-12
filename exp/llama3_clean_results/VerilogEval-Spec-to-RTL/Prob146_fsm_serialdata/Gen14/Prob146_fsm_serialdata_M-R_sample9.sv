module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
reg [1:0] state;
reg [1:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        state <= next_state;
        bit_counter <= next_bit_counter;
        if (state == STOP && in) begin
            out_byte <= data;
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

always @(*) begin
    next_state = state;
    next_bit_counter = bit_counter;
    case(state)
        IDLE: begin
            if (!in) begin
                next_state = START;
                next_bit_counter = 0;
            end
        end
        START: begin
            if (in) begin
                next_state = IDLE;
            end
            else begin
                next_state = DATA;
                next_bit_counter = 0;
            end
        end
        DATA: begin
            data = {data[6:0], in}; // Shift data to the left and add new bit at the LSB
            next_bit_counter = bit_counter + 1;
            if (bit_counter == 3'd7) begin
                next_state = STOP;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
                data <= 8'b0;
                next_bit_counter = 0;
            end
            else begin
                next_state = STOP; // Stay in STOP until a 1 is received
            end
        end
    endcase
end

endmodule