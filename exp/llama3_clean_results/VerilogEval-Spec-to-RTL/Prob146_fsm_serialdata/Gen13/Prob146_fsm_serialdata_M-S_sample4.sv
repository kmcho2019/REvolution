module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // States: IDLE (0), START (1), DATA (2), STOP (3)
reg [2:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        state <= next_state;
        bit_counter <= next_bit_counter;
        case(next_state)
            3: begin // STOP
                out_byte <= data;
                done <= 1;
            end
            default: begin
                done <= 0;
            end
        endcase
    end
end

always @(*) begin
    next_state = state;
    next_bit_counter = bit_counter;
    case(state)
        0: begin // IDLE
            if (!in) begin
                next_state = 1; // START
                next_bit_counter = 0;
            end
        end
        1: begin // START
            if (in) begin
                next_state = 0; // IDLE
            end
            else begin
                next_state = 2; // DATA
                next_bit_counter = 0;
            end
        end
        2: begin // DATA
            data = {data[6:0], in}; // Shift data to the left and add new bit at the LSB
            next_bit_counter = bit_counter + 1;
            if (bit_counter == 3'd7) begin
                next_state = 3; // STOP
            end
        end
        3: begin // STOP
            if (in) begin
                next_state = 0; // IDLE
                data <= 8'b0;
                next_bit_counter = 0;
            end
            else begin
                next_state = 3; // Stay in STOP until a 1 is received
            end
        end
    endcase
end

endmodule