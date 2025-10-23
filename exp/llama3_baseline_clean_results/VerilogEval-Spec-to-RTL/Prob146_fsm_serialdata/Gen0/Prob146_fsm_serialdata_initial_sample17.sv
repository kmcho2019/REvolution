module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // idle (0), start_bit (1), data_bits (2-9), stop_bit (10)
reg [2:0] data_bit_counter;
reg [7:0] data_byte;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        data_bit_counter <= 0;
        out_byte <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (!in) begin // start bit detected
                    state <= 1; // start_bit
                    data_bit_counter <= 0;
                end else begin
                    state <= 0; // stay in idle
                end
            end
            1: begin // start_bit
                state <= 2; // data_bits
            end
            2: begin // data_bits
                data_byte[data_bit_counter] <= in;
                data_bit_counter <= data_bit_counter + 1;
                if (data_bit_counter == 7) begin
                    state <= 10; // stop_bit
                end
            end
            10: begin // stop_bit
                if (in) begin // stop bit correct
                    out_byte <= data_byte;
                    done <= 1;
                    state <= 0; // idle
                end else begin // stop bit incorrect, wait for stop bit
                    state <= 10; // stay in stop_bit
                end
            end
            default: begin
                state <= 0; // idle
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state != 10) begin // not in stop_bit state
        done <= 0;
    end
end

endmodule