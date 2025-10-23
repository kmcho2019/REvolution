module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
    end
    else begin
        state <= next_state;
        data <= (next_state == 3'b010) ? {data[6:0], in} : data;
        bit_counter <= next_bit_counter;
        done <= (next_state == 3'b100 && in) ? 1 : 0;
        if (next_state == 3'b100 && in) begin
            out_byte <= data;
        end
    end
end

always @(*) begin
    case(state)
        3'b000: begin // IDLE
            if (!in) begin // Start bit detected
                next_state = 3'b001; // Transition to START state
                next_bit_counter = 3'b000;
            end
            else begin // Wait for start bit
                next_state = 3'b000;
                next_bit_counter = 3'b000;
            end
        end
        3'b001: begin // START
            next_state = 3'b010; // Move to DATA state
            next_bit_counter = 3'b000;
        end
        3'b010: begin // DATA
            next_bit_counter = bit_counter + 1;
            if (bit_counter == 3'd7) begin // 8 bits received
                next_state = 3'b100; // Transition to STOP state
            end
            else begin
                next_state = 3'b010;
            end
        end
        3'b100: begin // STOP
            if (in) begin // Stop bit detected, reset to IDLE
                next_state = 3'b000;
                next_bit_counter = 3'b000;
            end
            else begin // Incorrect stop bit, wait for stop bit
                next_state = 3'b100;
                next_bit_counter = 3'b000;
            end
        end
        default: begin
            next_state = 3'b000; // Ensure IDLE state on any other condition
            next_bit_counter = 3'b000;
        end
    endcase
end

endmodule