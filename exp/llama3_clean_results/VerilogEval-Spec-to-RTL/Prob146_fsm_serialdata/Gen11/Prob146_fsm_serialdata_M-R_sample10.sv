module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

parameter IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b100;

reg [2:0] state;
reg [2:0] next_state;
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
        data <= (next_state == DATA)? {data[6:0], in} : data;
        bit_counter <= next_bit_counter;
        if (next_state == STOP && in) begin
            out_byte <= data;
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

assign next_bit_counter = (state == DATA)? bit_counter + 1 : 3'b000;

always @(*) begin
    case(state)
        IDLE: begin
            if (!in) begin
                next_state = START;
            end
            else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (bit_counter == 3'd7) begin
                next_state = STOP;
            end
            else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
            end
            else begin
                next_state = STOP;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule