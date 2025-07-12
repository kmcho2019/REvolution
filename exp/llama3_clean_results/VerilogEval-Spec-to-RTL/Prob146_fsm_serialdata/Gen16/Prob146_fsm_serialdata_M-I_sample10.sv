module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states as an enumeration
enum logic [1:0] {IDLE, START, DATA_STOP} state, next_state;

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
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                end
            end
            START: begin
                state <= DATA_STOP;
                bit_counter <= 0;
                data[0] <= in; // store data bits in the correct order
            end
            DATA_STOP: begin
                bit_counter <= bit_counter + 1;
                if (bit_counter < 7) begin
                    data[bit_counter + 1] <= in; // store data bits in the correct order
                end
                else if (in) begin
                    out_byte <= data;
                    done <= 1;
                    state <= IDLE;
                end
                else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule