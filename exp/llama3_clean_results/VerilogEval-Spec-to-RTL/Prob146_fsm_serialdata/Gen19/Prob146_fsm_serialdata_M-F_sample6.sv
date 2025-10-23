module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states as an enumeration
enum logic [1:0] {IDLE, DATA, STOP_BIT} state, next_state;

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
                    state <= DATA;
                    bit_counter <= 0;
                end
                else begin
                    state <= IDLE;
                end
            end
            DATA: begin
                data[7 - bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter < 8) begin
                    state <= DATA;
                end
                else begin
                    state <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    out_byte <= data;
                    done <= 1;
                    state <= IDLE;
                end
                else begin
                    state <= STOP_BIT;
                end
            end
        endcase
    end
end

// Combinational logic for done
always @(posedge clk) begin
    if (state == IDLE &&!done) begin
        done <= 0;
    end
end

endmodule