module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states
parameter IDLE = 2'b00;
parameter DATA = 2'b01;
parameter STOP = 2'b10;

// Current state of the FSM
reg [1:0] state;
reg [1:0] next_state;

// Current bit counter
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

// Data register to store the received bits
reg [7:0] data;
reg [7:0] next_data;

// Sequential logic to update the registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        data <= 8'b0;
    end
    else begin
        state <= next_state;
        bit_counter <= next_bit_counter;
        data <= next_data;
    end
end

// Combinational logic to determine the next state and output
always @(*) begin
    next_state = state;
    next_bit_counter = bit_counter;
    next_data = data;
    done = 0;

    case(state)
        IDLE: begin
            if (!in) begin
                next_state = DATA;
                next_bit_counter = 0;
            end
        end
        DATA: begin
            next_data[7 - bit_counter] = in;
            next_bit_counter = bit_counter + 1;
            if (bit_counter == 7) begin
                next_state = STOP;
            end
        end
        STOP: begin
            if (in) begin
                out_byte = data;
                done = 1;
                next_state = IDLE;
            end
        end
    endcase
end

endmodule