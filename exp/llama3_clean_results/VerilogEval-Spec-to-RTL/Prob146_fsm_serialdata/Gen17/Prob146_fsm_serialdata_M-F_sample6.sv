module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states as an enumeration
enum logic [1:0] {IDLE, START, DATA, STOP_BIT} state, next_state;

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
                else if (in) begin // Wait for a stop bit before attempting to receive the next byte
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                bit_counter <= 0;
                data[0] <= in; // Store the start bit as the least significant bit of the data
            end
            DATA: begin
                bit_counter <= bit_counter + 1;
                if (bit_counter < 7) begin
                    data[bit_counter + 1] <= in; // Store data bits in the correct order
                    state <= DATA;
                end
                else begin
                    data[7] <= in; // Store the most significant bit
                    state <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit received
                    out_byte <= data;
                    done <= 1;
                    state <= IDLE;
                end
                else begin // Stop bit not received, stay in STOP_BIT state
                    state <= STOP_BIT;
                end
            end
        endcase
    end
end

// Combinational logic for done
always @(*) begin
    if (state == STOP_BIT && in) begin
        done = 1;
    end
    else begin
        done = 0;
    end
end

endmodule