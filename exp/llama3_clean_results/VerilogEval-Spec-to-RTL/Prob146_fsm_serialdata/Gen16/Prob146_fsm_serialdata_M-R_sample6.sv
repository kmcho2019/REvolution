module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states as an enumeration
enum logic [2:0] {IDLE, START, DATA, STOP} state, next_state;

// Current bit counter
reg [2:0] bit_counter;

// Data register to store the received bits
reg [7:0] data;

// Sequential logic to update the registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if (!in) begin
                    next_state <= START;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                next_state <= DATA;
                bit_counter <= 1;
                data[0] <= in;
            end
            DATA: begin
                bit_counter <= bit_counter + 1;
                data[bit_counter - 1] <= in;
                if (bit_counter == 8) begin
                    next_state <= STOP;
                end
                else begin
                    next_state <= DATA;
                end
            end
            STOP: begin
                done <= in;
                out_byte <= data;
                if (in) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= STOP;
                end
            end
        endcase
    end
end

endmodule