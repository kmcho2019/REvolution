module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
    end else begin
        state <= next_state;
        data <= (next_state == DATA) ? {data[6:0], in} : data;
        bit_counter <= next_bit_counter;
        if (next_state == STOP && in) begin
            out_byte <= data;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    case(state)
        IDLE: begin
            if (!in) begin
                next_state = START;
                next_bit_counter = 3'b000;
            end else begin
                next_state = IDLE;
                next_bit_counter = 3'b000;
            end
        end
        START: begin
            next_state = DATA;
            next_bit_counter = 3'b001;
        end
        DATA: begin
            if (bit_counter == 3'd7) begin
                next_state = STOP;
                next_bit_counter = 3'b000;
            end else begin
                next_state = DATA;
                next_bit_counter = bit_counter + 1;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
                next_bit_counter = 3'b000;
            end else begin
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