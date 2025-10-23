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
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
                bit_counter <= 0;
            end
            DATA: begin
                data[bit_counter] <= in; // store data bits in the correct order
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
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

// Combinational logic to determine the done signal
assign done = (state == STOP && in);

endmodule